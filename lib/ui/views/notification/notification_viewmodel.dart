import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/models/notification.dart';
import 'package:FSOUNotes/services/funtional_services/firebase_firestore/firestore_service.dart';
import 'package:stacked/stacked.dart';

class NotificationViewModel extends FutureViewModel {
  
  FirestoreService _firestoreService = locator<FirestoreService>();
  List<Notification> notifications = [];
  
  @override
  Future futureToRun() async {
    notifications = await _firestoreService.loadNotificationsFromFirebase();
  }

}