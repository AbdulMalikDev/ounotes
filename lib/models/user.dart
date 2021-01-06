class User{
  final String username;
  final String email;
  final String createdAt;
  final String semester;
  final String branch;
  final String id;
  final String photoUrl;
  String college;
  bool isPremiumUser;

  //is user signed in?
  bool isAuth;

  //is user admin?
  bool isAdmin = false;

  //is user allowed to upload?
  bool isUserAllowedToUpload = true;

  // Google sign in credentials
  Map<String,String> googleSignInAuthHeaders;

  //User uploads
  List uploads;

  //Upload stats of user
  int numOfUploads;
  int numOfAcceptedUploads;

  // FCM token
  String fcmToken;

  User({this.username, this.email, this.createdAt, this.semester, this.branch, this.college,this.isAuth,this.id,this.photoUrl,this.isUserAllowedToUpload,this.googleSignInAuthHeaders,this.fcmToken,this.isPremiumUser});

  User.fromData(Map<String,dynamic> data)
  : username                  = data['Username'],
    email                     = data['email'],
    createdAt                 = data['createdAt'].toString(),
    semester                  = data['Semester'],
    branch                    = data['Branch'],
    college                   = data['College'],
    isAuth                    = data['isAuth'] ?? false,
    id                        = data['id'],
    isPremiumUser             = data['isPremiumUser'],
    fcmToken                  = data['fcmToken'],
    photoUrl                  = data['photoUrl'],
    isAdmin                   = data['isAdmin'] ?? false,
    uploads                   = data["uploads"],
    numOfUploads              = data["numOfUploads"],
    numOfAcceptedUploads      = data["numOfAcceptedUploads"],
    isUserAllowedToUpload     = data['isUserAllowedToUpload'] ?? true;


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
      if(uploads!=null)"uploads"                          : uploads,
      if(numOfUploads!=null)"numOfUploads"                : numOfUploads,
      if(numOfAcceptedUploads!=null)"numOfAcceptedUploads": numOfAcceptedUploads,
      if(isPremiumUser!=null)"isPremiumUser"              : isPremiumUser,
         "isUserAllowedToUpload"                          : isUserAllowedToUpload ?? true,
    };
  }

    set setAdmin(bool value){this.isAdmin = value;}

    set setPremiumUser(bool value){this.isPremiumUser = value;}

    // "!value" because if we want to ban user (i.e send true) we need to set isUserAllowedToUpload to false
    set banUser(bool value){this.isUserAllowedToUpload = !value;}

    set setIsUserAllowedToUpload(bool value){this.isUserAllowedToUpload = false;}

    // incrementUploads(){if(numOfUploads==null){numOfUploads=0;} numOfUploads++;}

    // incrementAcceptedUploads(){if(numOfAcceptedUploads==null){numOfAcceptedUploads=0;} numOfAcceptedUploads++;}

    // addToUploadedDocuments(String documentId){if(uploads==null){uploads=[];}uploads.add(documentId);}
}