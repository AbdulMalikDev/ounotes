

import 'dart:convert';
import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/services/funtional_services/remote_config_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:stacked_services/stacked_services.dart';

Logger log = getLogger("AnalyticsService");
@lazySingleton
class AnalyticsService{

  DialogService _dialogService = locator<DialogService>();
  RemoteConfigService _remoteConfigService = locator<RemoteConfigService>();
  

  final FirebaseAnalytics analytics = FirebaseAnalytics();  
  

  void logEvent({String name,Map parameters,bool addInNotificationService=false}) async {
    try {
      if (parameters == null)
      {
        analytics.logEvent(name: name);
      }else{
        analytics.logEvent(name: name,parameters: parameters);
      }
      
      if (addInNotificationService && (parameters!=null)){
        OneSignal.shared.sendTags(parameters);
      }
    } catch (e) {
          log.e("Exception in logging event ${e.toString()}");
    }
  }

  void setUserProperty({String name, String value}) {
    //To comply with firebase character limit
    if((name?.length ?? 0) > 23){name = name.substring(0,22);}
    if((value?.length ?? 0) > 35){value = value.substring(0,34);}
    analytics.setUserProperty(name: name, value: value);
  }

  void addTagInNotificationService({String key,dynamic value}){
    OneSignal.shared.sendTag(key, value);
  }

  sendNotification({String id , String title ,String message,bool isAdmin=false}) async {

    await _remoteConfigService.init();
    if(isAdmin){id = _remoteConfigService.remoteConfig.getString('ADMIN_ID');}
    
    if (id == null || id.length == 0){
      await _dialogService.showDialog(title: "NO ID",description: "NO ID");
      return;
    }


    var url = "https://onesignal.com/api/v1/notifications";
    var body = json.encode({'app_id':'${_remoteConfigService.remoteConfig.getString('ONESIGNAL_APP_ID')}', "contents": {"en": message??"No Message"} ,"headings": {"en": title??"Test"} , "channel_for_external_user_ids": "push","include_external_user_ids": ["$id"]});
    http.Response response = await http.post(
        url,
        headers: {"Content-Type": "application/json","Authorization": "Basic ${_remoteConfigService.remoteConfig.getString('ONESIGNAL_API_KEY')}"},
        body: body,
      );

      
    // playerID is current users ID but we need the id of the user who reported 
    // var status = await OneSignal.shared.getPermissionSubscriptionState();
    // var playerId = status.subscriptionStatus.userId;
  }
  
}