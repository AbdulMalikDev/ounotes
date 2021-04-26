import 'dart:math';


import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.logger.dart';
import 'package:FSOUNotes/app/app.router.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:open_file/open_file.dart';
Logger log = getLogger("NotificationService");



class NotificationService{

  NavigationService _navigationService = locator<NavigationService>();

  static const download_purchase_notify = "DownloadPurchase";
  static const premium_purchase_notify = "PremiumPurchase";
  static const premium_expire_notify = "PremiumExpire";
  static const download_purchase_notify_id = 1;
  static const premium_purchase_notify_id = 2;
  static const premium_expire_notify_id = 3;

  static const List<String> notifyKeys = [download_purchase_notify,premium_purchase_notify,premium_expire_notify];

  init() async {
    await AwesomeNotifications().initialize(
        // set the icon to null if you want to use the default app icon
        'resource://drawable/ic_launcher',
        [
            NotificationChannel(
                enableVibration: true,
                channelKey: download_purchase_notify,
                channelName: 'Notify Downloads',
                channelDescription: 'Notification channel for downloads',
                defaultColor: Colors.green,
                ledColor: Colors.white
            ),
            NotificationChannel(
                enableVibration: true,
                channelKey: premium_purchase_notify,
                channelName: 'Notify Premium Subscription',
                channelDescription: 'Notification channel for Premium Subscription',
                defaultColor: Colors.yellow,
                ledColor: Colors.white
            ),
        ]
    );
    AwesomeNotifications().actionStream.listen(
        (receivedNotification){
          log.e(receivedNotification.toString());
          handleLocalNotification(receivedNotification);
        }
    );
  }

  handleLocalNotification(ReceivedAction receivedNotification) {
    final payload = receivedNotification.payload;

    if(!notifyKeys.contains(receivedNotification.id)){
      OpenFile.open(payload["path"]);
    }

    switch(receivedNotification.id){
      case premium_purchase_notify_id:
        _navigationService.navigateTo(Routes.thankYouView);
        break;
      case premium_expire_notify_id:
        //TODO Update thankyou view to urge user to buy premium again since it has expired
        // _navigationService.navigateTo(Routes.thankYouView);
        break;
      default:
        break;
    }
  }

  dispatchLocalNotification(String key,Map customData) async {
    int id = new Random().nextInt(500);
    switch(key){
      case download_purchase_notify:
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: id,
              channelKey: download_purchase_notify,
              title: customData["title"],
              body: customData["body"],
              payload: customData["payload"],
          )
        );
        break;
      case premium_purchase_notify:
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: premium_purchase_notify_id,
              channelKey: premium_purchase_notify,
              title: customData["title"],
              body: customData["body"],
          )
        );
        break;
      case premium_expire_notify:
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: premium_expire_notify_id,
              channelKey: premium_purchase_notify,
              title: customData["title"],
              body: customData["body"],
          )
        );
        break;
      default:
        break;
    }
  }

}