
import 'package:FSOUNotes/app/logger.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';
Logger log = getLogger("InAppPaymentService");
@lazySingleton
class InAppPaymentService {

  // bool isPro = false;
  // // ValueNotifier<Offerings> _offerings;
  // // ValueNotifier<PurchaserInfo> _purchaserInfo;

  // ValueNotifier<Offerings> get offerings => _offerings;
  // ValueNotifier<PurchaserInfo> get purchaserInfo => _purchaserInfo;

  // Future<void> fetchData() async {
  //   PurchaserInfo purchaserInfo;

  //   try {
  //     purchaserInfo = await Purchases.getPurchaserInfo();
  //   } on PlatformException catch (e) {
  //     print(e);
  //   }

  //   Offerings offerings;
  //   try {
  //     offerings = await Purchases.getOfferings();
  //   } on PlatformException catch (e) {
  //     print(e);
  //   }
  //   if(_purchaserInfo==null)_purchaserInfo = new ValueNotifier(purchaserInfo);
  //   else _purchaserInfo.value = purchaserInfo;
  //   if(_offerings==null)_offerings = new ValueNotifier(offerings);
  //   else _offerings.value = offerings;
    
  // }

  // Future<Package> purchaseDownloadPackage() async {
  //   try {
  //     if(_offerings == null || _offerings.value == null)await fetchData();
  //     Package downloadPackage = _offerings.value.current.availablePackages[0];
  //     log.e(downloadPackage);
  //     _purchaserInfo.value = await Purchases.purchasePackage(downloadPackage);
  //     isPro = _purchaserInfo.value.entitlements.all["pdf_downloader"].isActive;
  //     return downloadPackage;
  //   } catch (e) {
  //     log.e(e.toString());
  //   }
  // }


}