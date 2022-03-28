import 'package:flutter/cupertino.dart';

class Notification {
  String id;
  String userId;
  String heading;
  String body;
  String time;

  Notification({this.id, this.userId, this.heading, this.body, this.time});

  Notification.fromData(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    heading = json['heading'];
    body = json['body'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['heading'] = this.heading;
    data['body'] = this.body;
    data['time'] = this.time;
    return data;
  }
}
