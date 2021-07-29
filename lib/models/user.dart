import 'package:FSOUNotes/app/app.logger.dart';
import 'package:logger/logger.dart';

Logger log = getLogger("User.dart");
class User{
  String id;
  String username;
  String email;
  String createdAt;
  String semester;
  String branch;
  String photoUrl;
  String college;
  bool isPremiumUser;
  DateTime premiumPurchaseDate;

  //is user signed in?
  bool isAuth;

  //is user admin?
  bool isAdmin = false;

  //is user verifier?
  bool isVerifier = false;

  //is user allowed to upload?
  bool isUserAllowedToUpload = true;

  //Note Ids Downloaded
  List downloads = [];

  //User uploads
  List uploads;

  //Upload stats of user
  int numOfUploads;
  int numOfAcceptedUploads;

  // FCM token
  String fcmToken;

  User({this.username, this.email, this.createdAt, this.semester, this.branch, this.college,this.isAuth,this.id,this.photoUrl,this.isUserAllowedToUpload,this.fcmToken,this.isPremiumUser,this.premiumPurchaseDate});

  User.fromData(Map<String,dynamic> data)
  {  
    id                    = data['id'];
    email                 = data['email'];
    branch                = data['Branch'];
    isAuth                = data['isAuth'] ?? false;
    college               = data['College'];
    isAdmin               = data['isAdmin'] ?? false;
    isVerifier               = data['isVerifier'] ?? false;
    uploads               = data["uploads"];
    semester              = data['Semester'];
    username              = data['Username'];
    fcmToken              = data['fcmToken'];
    premiumPurchaseDate   = _parseDate(data['premiumPurchaseDate']);
    photoUrl              = data['photoUrl'];
    downloads             = data["downloads"] ?? [];
    createdAt             = data['createdAt'].toString();
    numOfUploads          = data["numOfUploads"];
    isPremiumUser         = data['isPremiumUser'] ?? false;
    numOfAcceptedUploads  = data["numOfAcceptedUploads"];
    isUserAllowedToUpload = data['isUserAllowedToUpload'] ?? true;
  }


  Map<String,dynamic> toJson() {
    return {
               "Username"                                       : username,
               "email"                                          : email,
               "createdAt"                                      : createdAt.toString(),
               "Semester"                                       : semester,
               "Branch"                                         : branch,
               "College"                                        : college,
               "isAuth"                                         : isAuth ?? false,
               "id"                                             : id,
               "photoUrl"                                       : photoUrl,
               "fcmToken"                                       : fcmToken,
               "isAdmin"                                        : isAdmin ?? false,
               "isVerifier"                                     : isVerifier ?? false,
               "isUserAllowedToUpload"                          : isUserAllowedToUpload ?? true,
            if(uploads!=null)"uploads"                          : uploads,
            if(numOfUploads!=null)"numOfUploads"                : numOfUploads,
            if(numOfAcceptedUploads!=null)"numOfAcceptedUploads": numOfAcceptedUploads,
            if(isPremiumUser!=null)"isPremiumUser"              : isPremiumUser,
            if(downloads!=null)"downloads"                      : downloads,
            if(premiumPurchaseDate!=null)"premiumPurchaseDate"  : premiumPurchaseDate,
    };
  }

    set setAdmin(bool value){this.isAdmin = value;}
    set setVerifier(bool value){this.isVerifier = value;}

    set setPremiumUser(bool value){this.isPremiumUser = value;}

    addDownload(String id){this.downloads.add(id);}

    // "!value" because if we want to ban user (i.e send true) we need to set isUserAllowedToUpload to false
    set banUser(bool value){this.isUserAllowedToUpload = !value;}

    set setIsUserAllowedToUpload(bool value){this.isUserAllowedToUpload = false;}

    _parseDate(date){
      DateTime purchaseDate;
      log.e(purchaseDate);
      try{purchaseDate = DateTime.parse(date?.toDate()?.toString() ?? DateTime.now().toString());}
      catch(e){log.e(e.toString());return null;}
      return purchaseDate;
    }
}