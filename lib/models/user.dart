class User{
  final String username;
  final String email;
  final String createdAt;
  final String semester;
  final String branch;
  final String college;
  final String id;
  final String photoUrl;

  //is user signed in?
  bool isAuth;

  //is user admin?
  bool isAdmin = false;

  //is user allowed to upload?
  bool isUserAllowedToUpload = true;


  User({this.username, this.email, this.createdAt, this.semester, this.branch, this.college,this.isAuth,this.id,this.photoUrl,this.isUserAllowedToUpload});

  User.fromData(Map<String,dynamic> data)
  : username  = data['Username'],
    email     = data['email'],
    createdAt = data['createdAt'].toString(),
    semester  = data['Semester'],
    branch    = data['Branch'],
    college   = data['College'],
    isAuth    = data['isAuth'] ?? false,
    id        = data['id'],
    photoUrl  = data['photoUrl'],
    isAdmin   = data['isAdmin'] ?? false,
    isUserAllowedToUpload   = data['isUserAllowedToUpload'] ?? true;


  Map<String,dynamic> toJson() {
    return {
      "Username" : username,
      "email"    : email,
      "createdAt": createdAt.toString(),
      "Semester" : semester,
      "Branch"   : branch,
      "College"  : college,
      "isAuth"   : isAuth ?? false,
      "id"       : id,
      "photoUrl" : photoUrl,
      "isAdmin"  : isAdmin ?? false,
      "isUserAllowedToUpload"  : isUserAllowedToUpload ?? true,
    };
  }

    set setAdmin(bool value){this.isAdmin = value;}

    set setIsUserAllowedToUpload(bool value){this.isUserAllowedToUpload = false;}
}