import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/enums/confidential.dart';
import 'package:FSOUNotes/models/user.dart';
import 'package:FSOUNotes/services/funtional_services/analytics_service.dart';
import 'package:FSOUNotes/services/funtional_services/firestore_service.dart';
import 'package:FSOUNotes/services/funtional_services/sharedpref_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

@lazySingleton
class AuthenticationService {
  //Class Logger
  Logger log = getLogger("AuthenticationService");

  FirestoreService _firestoreService = locator<FirestoreService>();
  AnalyticsService _analyticsService = locator<AnalyticsService>();
  // OneSignal _oneSignal;

  final CollectionReference _usersCollectionReference = Firestore.instance.collection("users");

  //Sign in related variables
  GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  GoogleSignInAccount _googleUser;
  GoogleSignInAuthentication _googleSignInAuth;
  AuthCredential _credential;
  FirebaseUser _firebaseUser;
  User _user;

  //Getters and Setters
  GoogleSignInAccount get googleUser => _googleUser;
  GoogleSignInAuthentication get googleSignInAuth => _googleSignInAuth;
  AuthCredential get credential => _credential;
  FirebaseUser get firebaseUser => _firebaseUser;
  User get user => _user;
  set setUser(User user) => _user=user;

 Future<bool> handleSignIn({
    String college,
    String branch,
    String semeseter,
  }) async {
   
    _googleUser = await googleSignIn.signIn().catchError((e){
      log.e("ERROR AUTHENTICATING : ${e.toString()}");
      return null;
    });
    _googleSignInAuth = await googleUser.authentication;
    _credential = GoogleAuthProvider.getCredential(
      idToken: _googleSignInAuth.idToken,
      accessToken: _googleSignInAuth.accessToken,
    );

    _firebaseUser = (await firebaseAuth.signInWithCredential(credential)).user;

    bool isAdmin = Confidential.run(_firebaseUser.email);
    log.e(isAdmin);
    if (isAdmin)
    {
      googleSignIn = GoogleSignIn(scopes: ['https://www.googleapis.com/auth/drive']);
      googleSignIn.signInSilently().whenComplete(() => () {});
    }

    _user = new User(
      email: _firebaseUser.email,
      branch: branch,
      semester: semeseter,
      college: college,
      createdAt: DateTime.now().toString(),
      id:_firebaseUser.uid,
      isAuth: true,
      photoUrl: _firebaseUser.photoUrl,
      username: _firebaseUser.displayName,
      // googleSignInAuthHeaders: await _googleUser.authHeaders,
    );
   if (isAdmin){_user.setAdmin=true;}
   

    //Add User to Firebase
    await _firestoreService.saveUser(_user.toJson());

    //Add User To Local Storage
    SharedPreferencesService _sharedPreferencesService = locator<SharedPreferencesService>();
    await _sharedPreferencesService.saveUserLocally(_user);

    // Add this event Analytics
    _addEventInfo(_user);

    if(_firebaseUser!=null){
      return true;
    }else{
      return false;
    }

  }
    
  Future<bool> handleSignOut() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      await FirebaseAuth.instance.signOut();
      await googleSignIn.disconnect();
      await googleSignIn.signOut().catchError((e) {
        return false;
      });
    }
    SharedPreferencesService _sharedPreferencesService = locator<SharedPreferencesService>();
    User userr=User(isAuth: false);
    await _sharedPreferencesService.saveUserLocally(userr);
    //Store in state
    _user = userr;
    return true;
  }
  
  // *For Admins
  refreshSignInCredentials() async {
      googleSignIn = GoogleSignIn(scopes: ['https://www.googleapis.com/auth/drive']);
      GoogleSignInAccount ga = await googleSignIn.signInSilently().whenComplete(() => () {});
      return ga.authHeaders;
  }

  Future<User> getUser() async {

    if (_user == null){
      SharedPreferencesService _sharedPreferencesService = locator<SharedPreferencesService>();
      User user = await _sharedPreferencesService.getUser();
      return user;
    }else{
      return _user;
    }
  }
  
  void _addEventInfo(User user) {
    _analyticsService.logEvent(name:"LogIn",parameters:_user.toJson());
    _analyticsService.setUserProperty(name: 'college', value: _user.college);
    _analyticsService.setUserProperty(name: 'branch', value: _user.branch);
    _analyticsService.setUserProperty(name: 'semester', value: _user.semester);
    Map<String, dynamic> tags = {
      "college" : _user.college,
      "branch" : _user.branch,
      "semester" : _user.semester,
      "email" : _user.email,
      "username" : _user.username,
    };
    OneSignal.shared.sendTags(tags);
    OneSignal.shared.setEmail(email:_user.email);
    OneSignal.shared.setExternalUserId(_user.id);
    OneSignal.shared.setLocationShared(true);
  }

  
}
