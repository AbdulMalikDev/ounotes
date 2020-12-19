
import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/router.gr.dart';
import 'package:FSOUNotes/enums/bottom_sheet_type.dart';
import 'package:FSOUNotes/enums/constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked_services/stacked_services.dart';

@lazySingleton
class PushNotificationService{
  final FirebaseMessaging fcm = FirebaseMessaging();

  NavigationService _navigationService = locator<NavigationService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();

  Future initialise() async {

    fcm.configure(
      //When the app is in foreground
      onMessage: (Map<String,dynamic> message) async {
        print("onMessage : $message");
        await _handleNotification(message);
      }, 
      //When app started from dead state
      onLaunch: (Map<String,dynamic> message) async {
        print("onLaunch : $message");
        await Future.delayed(Duration(seconds: 2),(){});
        _handleNotification(message);
      }, 
      //When app was in background
      onResume: (Map<String,dynamic> message) async {
        print("onResume : $message");
        _handleNotification(message);
      }, 
    );

  }

  _handleNotification(message) async {
    String title             = message["data"]["title"];
    String body              = message["data"]["body"];
    String subjectName       = message["data"]["subjectName"];
    bool navigate            = (message["data"]["navigate"] ?? "false") == "true" ? true : false ;
    String notesID           = message["data"]["notesID"];
    String notificationEvent = message["data"]["notificationEvent"];

    switch(notificationEvent){
      case Constants.notificationEventNotesUpload:
        _handleNotesUpload(title,body,subjectName,navigate,notesID);
        break;

      default:
        break;
    }
    
  }

  _handleNotesUpload(String title,String body,String subjectName,bool navigate,String notesID) async {
    if(title==null || body == null || subjectName == null)return;
    SheetResponse wantToCheckOutNotification = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.filledStacks,
      title: title,
      description: body,
      mainButtonTitle: "OK",
      secondaryButtonTitle: "Later"
    );
    bool shouldNavigate = navigate && (wantToCheckOutNotification?.confirmed ?? false);
    if(shouldNavigate)_navigationService.navigateTo(Routes.allDocumentsViewRoute,arguments: AllDocumentsViewArguments(subjectName: subjectName,newDocIDUploaded: notesID));
  }

  // ignore: non_constant_identifier_names
  void handleFcmTopicUnSubscription(String fcm_semester,String fcm_branch,String fcm_college,String user_semester,String user_branch,String user_college) {
    List fcm = [fcm_semester,fcm_branch,fcm_college];
    List user = [user_semester,user_branch,user_college];

    fcm.asMap().forEach((index, value) {
      if(value == null)return;

      if(user[index]!=value){
        this.fcm.unsubscribeFromTopic(value);
      }
    });
  }
}