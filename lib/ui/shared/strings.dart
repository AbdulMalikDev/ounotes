import 'package:FSOUNotes/models/notes.dart';

class Strings{

  //Notification Strings
  static const admin_document_upload_notification_title = "New Document Uploaded ⬆️ !";
  static const admin_document_upload_notification_message = "A new document has been uploaded";
  static const admin_document_report_notification_title = "Document Reported ⚠️ !";
  static const admin_document_report_notification_message = "A document has been reported";
  static const thank_user_notification_title = "Thank You! 🎉";
  static String thank_user_notification_message(Note note) => "Someone thanked you ✨ for uploading ${note.title} in ${note.subjectName}";

  //Authentication_service.dart
  static const fcm_token_permission_title = "Get Notified 🔔 !";
  static const fcm_token_permission_description = "Do you want us to notify you when new notes for your Semester are uploaded ?";
  static const fcm_token_permission_main_button = "YES !";
  static const fcm_token_permission_secondary_button = "NEVER";



  //uploadLogDetailView.dart
  static String upload_log_adminmsg_notification_title = "✉️ Message from OU Notes Admin ✨";
  static String upload_log_adminmsg_notification_body = "";
  static String upload_log_accept_notification_title(uploadLog) => "Thank you for uploading ${uploadLog.uploader_name ?? ''} !!";
  static String upload_log_accept_notification_body(uploadLog) => "We have reviewed the document you have uploaded \" ${uploadLog.fileName} \" in the \" ${uploadLog.subjectName} \" subject and it is LIVE ! Thank you again for making OU Notes a better place and helping all of us !";
  static String upload_log_deny_notification_title(uploadLog) => "Thank you for uploading ${uploadLog.uploader_name ?? ''} !!";
  static String upload_log_deny_notification_body(uploadLog) => "We have reviewed the document you have uploaded \" ${uploadLog.fileName} \" in the \" ${uploadLog.subjectName} \" subject and the document does not match our standards. Please try again with a better document. Feel free to contact us using the feedback feature !";
  static const upload_log_ban_notification_title = "We're Sorry !";
  static const upload_log_ban_notification_body = "We're sad to say that you won't be allowed to report or upload any documents. Feel free to contact us using the feedback feature !";
}