import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/models/user.dart';
import 'package:logger/logger.dart';

Logger log = getLogger("Confidential");

class Confidential{
  static List<String> emails = ["mam7264@gmail.com" , "syedwajid3399@gmail.com"];

  static void run(User user) {
     if(Confidential.emails.firstWhere((email) => email==user.email,orElse: ()=>null)!=null){
      user.setAdmin=true;
      log.w("Admin logged in. Privilege escalated.");
    }
  }
}