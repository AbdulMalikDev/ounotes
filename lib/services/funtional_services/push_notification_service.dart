
import 'dart:convert';

import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/app/router.gr.dart';
import 'package:FSOUNotes/enums/bottom_sheet_type.dart';
import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/services/funtional_services/remote_config_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:http/http.dart' as http;
Logger log = getLogger("PushNotificationService");

@lazySingleton
class PushNotificationService{
  final FirebaseMessaging fcm = FirebaseMessaging();

  NavigationService _navigationService = locator<NavigationService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  RemoteConfigService _remoteConfigService = locator<RemoteConfigService>();

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
  void handleFcmTopicUnSubscription
  (
    // ignore: non_constant_identifier_names
    String fcm_semester,String fcm_branch,
    // ignore: non_constant_identifier_names
    String fcm_college,String user_semester,
    // ignore: non_constant_identifier_names
    String user_branch,String user_college,
    String fcmToken,
  ) {

    if(fcm_semester==null||fcm_branch==null||fcm_college==null){
      _unSubscribeFromAll(fcmToken);
    }

    List fcm = [fcm_semester,fcm_branch,fcm_college];
    List user = [user_semester,user_branch,user_college];

    fcm.asMap().forEach((index, value) {
      if(value == null)return;

      if(user[index]!=value){
        this.fcm.unsubscribeFromTopic(value);
      }
    });

  }

  _unSubscribeFromAll(String fcmToken) async {
    log.i("User being unsubscribed from all the topics that existed for its account in the past");

    try {
      var url = "https://iid.googleapis.com/iid/info/$fcmToken?details=true";
      http.Response response = await http.get(
          url,
          headers: {"Content-Type": "application/json","Authorization": "Bearer ${_remoteConfigService.remoteConfig.getString('FCM_CLOUD')}"},
        );
      Map body = json.decode(response.body);
      bool hasFcmTopics = body["rel"] != null || body["error"]==null;
      if(hasFcmTopics){
        log.e(body["rel"]["topics"]);
        List topics = new Map.from(body["rel"]["topics"]).keys.toList();
        topics.forEach((topic) {
          this.fcm.unsubscribeFromTopic(topic);
        });
        log.e(topics);
      } 
    } catch (e) {
      log.e(e.toString());
    }
  }
}