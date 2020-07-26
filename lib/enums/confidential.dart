import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/models/user.dart';
import 'package:logger/logger.dart';

Logger log = getLogger("Confidential");

class Confidential{
  static List<String> emails = [];

  static void run(User user) {
     if(emails.firstWhere((email) => email==user.email,orElse: ()=>null)!=null){
      user.setAdmin=true;
      log.w("Admin logged in. Privilege escalated.");
    }
  }
}