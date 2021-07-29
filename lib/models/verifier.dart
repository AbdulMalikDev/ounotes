import 'package:FSOUNotes/models/user.dart';

class Verifier {
  String id;
  String name;
  String email;
  String semester;
  String branch;
  String college;
  String photoUrl;
  String fcmToken;
  bool isAdmin = false;
  bool isBanned = false;
  int numOfVerifiedDocs = 0;
  int numOfReportedDocs = 0;

  Verifier(
      {this.id,
      this.name,
      this.email,
      this.semester,
      this.branch,
      this.college,
      this.photoUrl,
      this.isAdmin,
      this.isBanned,
      this.numOfVerifiedDocs,
      this.numOfReportedDocs});

  Verifier.fromUser(User user){
    id = user.id;
    name = user.username;
    email = user.email;
    semester = user.semester;
    branch = user.branch;
    college = user.college;
    photoUrl = user.photoUrl;
    fcmToken = user.fcmToken ?? "";
    isAdmin = user.isAdmin;
    isBanned = false;
  }

  Verifier.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    email = json['Email'];
    semester = json['Semester'];
    branch = json['Branch'];
    college = json['College'];
    photoUrl = json['PhotoUrl'];
    fcmToken = json['fcmToken'];
    isAdmin = json['isAdmin'];
    isBanned = json['isBanned'];
    numOfVerifiedDocs = json['numOfVerifiedDocs'];
    numOfReportedDocs = json['numOfReportedDocs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Name'] = this.name;
    data['Email'] = this.email;
    data['Semester'] = this.semester;
    data['Branch'] = this.branch;
    data['College'] = this.college;
    data['PhotoUrl'] = this.photoUrl;
    data['fcmToken'] = this.fcmToken;
    data['isAdmin'] = this.isAdmin;
    data['isBanned'] = this.isBanned;
    data['numOfVerifiedDocs'] = this.numOfVerifiedDocs;
    data['numOfReportedDocs'] = this.numOfReportedDocs;
    return data;
  }
}
