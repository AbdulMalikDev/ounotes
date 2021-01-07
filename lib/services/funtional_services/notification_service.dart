import 'dart:math';

import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/router.gr.dart';
import 'package:injectable/injectable.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:stacked_services/stacked_services.dart';
import './../../app/logger.dart';
import 'package:open_file/open_file.dart';
Logger log = getLogger("NotificationService");


@lazySingleton
class NotificationService{

  NavigationService _navigationService = locator<NavigationService>();

  static const download_purchase_notify = "DownloadPurchase";
  static const premium_purchase_notify = "PremiumPurchase";
  static const download_purchase_notify_id = 1;
  static const premium_purchase_notify_id = 2;


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
    switch(receivedNotification.id){
      case download_purchase_notify_id:
        final payload = receivedNotification.payload;
        OpenFile.open(payload["path"]);
        break;
      case premium_purchase_notify_id:
        _navigationService.navigateTo(Routes.thankYouView);
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
              id: download_purchase_notify_id,
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
      default:
        break;
    }
  }

}