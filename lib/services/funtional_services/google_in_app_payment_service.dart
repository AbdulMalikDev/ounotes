
import 'dart:async';

import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.logger.dart';
import 'package:FSOUNotes/app/app.router.dart';
import 'package:FSOUNotes/models/notes.dart';
import 'package:FSOUNotes/models/user.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
import 'package:FSOUNotes/services/funtional_services/firebase_firestore/firestore_service.dart';
import 'package:FSOUNotes/services/funtional_services/google_drive_service.dart';
import 'package:FSOUNotes/services/funtional_services/notification_service.dart';
import 'package:FSOUNotes/services/funtional_services/onboarding_service.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:logger/logger.dart';
import 'package:stacked_services/stacked_services.dart';
Logger log = getLogger("GoogleInAppPaymentService");


class GoogleInAppPaymentService{

  static const String pdfProductID = 'ou_notes_pdf';
  static const String premiumProductID = 'ou_notes_pro_version';

  /// Is the API available on the device
  bool _available = true;

  ///Document to be downloaded
  Note note;

  /// The In App Purchase plugin
  InAppPurchaseConnection _iap ;

  /// Products for sale
  ValueNotifier<List<ProductDetails>> _products = new ValueNotifier(new List<ProductDetails>());

  /// Past purchases
  ValueNotifier<List<PurchaseDetails>> _purchases = new ValueNotifier(new List<PurchaseDetails>());

  /// Updates to purchases
  StreamSubscription subscription;

  /// Consumable credits the user can buy
  int _credits = 0;

  ValueNotifier<List<ProductDetails>> get products => _products;
  ValueNotifier<List<PurchaseDetails>> get purchases => _purchases;

  GoogleDriveService _googleDriveService = locator<GoogleDriveService>();
  NotificationService _notificationService = locator<NotificationService>();
  FirestoreService _firestoreService = locator<FirestoreService>();
  AuthenticationService _authenticationService = locator<AuthenticationService>();
  NavigationService _navigationService = locator<NavigationService>();

  initialize() async {
    log.e("started");
    _iap = InAppPurchaseConnection.instance;
    // Check availability of In App Purchases
    _available = await _iap.isAvailable();

    if (_available) {

      await getProducts();
      await getPastPurchases();

      // Verify and deliver a purchase with your own business logic
      verifyPurchase();
      log.e(_products.value);
      log.e(_purchases.value);

    }

    // Listen to new purchases
    subscription = _iap.purchaseUpdatedStream.listen((data) async {
      log.e("purchaseUpdatedStream UPDATED");
      _purchases.value.addAll(data);
      await verifyPurchase();
    });

  }

  /// Get all products available for sale
  Future<void> getProducts() async {
    Set<String> ids = Set.from([pdfProductID,premiumProductID]);
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);

    _products.value = response.productDetails;
    
  }

  /// Gets past purchases
  Future<void> getPastPurchases() async {
    QueryPurchaseDetailsResponse response =
        await _iap.queryPastPurchases();

    for (PurchaseDetails purchaseDetails in response.pastPurchases) {
      final pending = !purchaseDetails.billingClientPurchase.isAcknowledged;

        if (pending) {
          InAppPurchaseConnection.instance.completePurchase(purchaseDetails);
        }
    }

    _purchases.value = response.pastPurchases;
  }

  // Returns purchase of specific product ID
  PurchaseDetails hasPurchased(String productID) {
    return _purchases.value.firstWhere( (purchase) => purchase.productID == productID, orElse: () => null);
  }

  ProductDetails getProduct(String productID){
    return _products.value.firstWhere( (purchase) => purchase.id == productID, orElse: () => null);
  }

  /// Your own business logic to setup a consumable
  void verifyPurchase() async {
    PurchaseDetails purchase = hasPurchased(pdfProductID);

    List<PurchaseDetails> toRemove = [];
    for(PurchaseDetails purchaseItem in _purchases.value){
      if(purchaseItem.status == PurchaseStatus.purchased){
        await completePurchase(purchaseItem);
      }
      await toRemove.add(purchaseItem);
    }
    _purchases.value.removeWhere( (e) => toRemove.contains(e));
  }

   /// Purchase a product
  void buyProduct({ProductDetails prod,Note note}) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
    // _iap.buyNonConsumable(purchaseParam: purchaseParam);
    bool success = await _iap.buyConsumable(purchaseParam: purchaseParam, autoConsume: false);
    if(success && prod.id == pdfProductID)
    OnboardingService.box.put(GoogleInAppPaymentService.pdfProductID, "${note.subjectId}_${note.id}");
    else if(success && prod.id == premiumProductID)
    OnboardingService.box.put(GoogleInAppPaymentService.premiumProductID, premiumProductID);
  }

  /// Complete purchase and download PDF
  completePurchase(PurchaseDetails purchase) async {
    
      if(hasPurchased(purchase.productID) != null){
        var res = await _iap.consumePurchase(purchase);

        if(purchase.productID == pdfProductID)
        await _handlePurchasedPdfDownload();
        else if(purchase.productID == premiumProductID)
        await _handlePremiumPurchase();

      }
    
  }

  _handlePurchasedPdfDownload() async {
    await getPastPurchases();
    this.note = await _getNote();
    await _googleDriveService.downloadPuchasedPdf
    (
      note:note,
      startDownload: () {
        // setLoading(true);
      },
      onDownloadedCallback: (path,fileName) async {
        // setLoading(false);
        await _notificationService.dispatchLocalNotification(NotificationService.download_purchase_notify, {
            "title":"Downloaded " + fileName,
            "body" : "PDF File has been downloaded in the downloads folder. Thank you for using the OU Notes app.",
            "payload": {"path" : path},
          }
        );
        User user = await _authenticationService.getUser();
        user.addDownload("${this.note.subjectId}_${this.note.id}");
        await _firestoreService.updateUserInFirebase(user,updateLocally: true);
        _navigationService.navigateTo(Routes.thankYouView,arguments: ThankYouViewArguments(filePath: path));
      },
    );
  }

  _handlePremiumPurchase() async {
    log.e("User purchased premium");
    User user = await _authenticationService.getUser();
    user.setPremiumUser = true;
    user.premiumPurchaseDate = DateTime.now();
    await _firestoreService.updateUserInFirebase(user,updateLocally: true);
    await _notificationService.dispatchLocalNotification(NotificationService.premium_purchase_notify,{
        "title":"✨ Congratulations ! You are a premium user ! ✨",
        "body" : "Enjoy OU Notes Ad-free and download unlimited offline Notes and save Data !",
      }
    );
    _navigationService.navigateTo(Routes.thankYouView);
  }

  Future<Note> _getNote() async {
    String key = OnboardingService.box.get(pdfProductID);
    if(key == null)return null;

    String subjectId;
    String noteId;
    subjectId = key.split("_").toList()[0];
    noteId = key.split("_").toList()[1];
    return await _firestoreService.getNoteById(int.parse(subjectId), noteId);
  }

}