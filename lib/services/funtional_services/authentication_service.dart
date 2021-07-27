
import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/enums/bottom_sheet_type.dart';
import 'package:FSOUNotes/models/user.dart' as userModel;
import 'package:FSOUNotes/services/funtional_services/analytics_service.dart';
import 'package:FSOUNotes/services/funtional_services/firebase_firestore/firestore_service.dart';
import 'package:FSOUNotes/services/funtional_services/onboarding_service.dart';
import 'package:FSOUNotes/services/funtional_services/push_notification_service.dart';
import 'package:FSOUNotes/services/funtional_services/sharedpref_service.dart';
import 'package:FSOUNotes/ui/shared/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:FSOUNotes/misc/course_info.dart';
import 'package:FSOUNotes/app/app.logger.dart';


//TODO pura deprecate hogaya baigan ki meri

class AuthenticationService {
  //Class Logger
  Logger log = getLogger("AuthenticationService");

  FirestoreService _firestoreService = locator<FirestoreService>();
  AnalyticsService _analyticsService = locator<AnalyticsService>();
  PushNotificationService _pushNotificationService =
      locator<PushNotificationService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  // OneSignal _oneSignal;
  //Sign in related variables
  GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  GoogleSignInAccount _googleUser;
  GoogleSignInAuthentication _googleSignInAuth;
  AuthCredential _credential;
  User _firebaseUser;
  userModel.User _user;

  //Getters and Setters
  GoogleSignInAccount get googleUser => _googleUser;
  GoogleSignInAuthentication get googleSignInAuth => _googleSignInAuth;
  AuthCredential get credential => _credential;
  User get firebaseUser => _firebaseUser;
  userModel.User get user => _user;
  set setUser(userModel.User user) => _user = user;

  Future<bool> handleSignIn({
    String college,
    String branch,
    String semeseter,
  }) async {
    _googleUser = await googleSignIn.signIn().catchError((e) {
      _handleAuthError(e);
      return null;
    });
    if (_googleUser == null) {
      return false;
    }

    _googleSignInAuth = await googleUser.authentication;
    _credential = GoogleAuthProvider.credential(
      idToken: _googleSignInAuth.idToken,
      accessToken: _googleSignInAuth.accessToken,
    );

    _firebaseUser = (await firebaseAuth.signInWithCredential(credential)).user;

    IdTokenResult token = await _firebaseUser.getIdTokenResult(true);
    bool isAdmin = token?.claims["admin"] ?? false;
    log.e("isAdmin : " + isAdmin.toString());

    if (isAdmin) {
      googleSignIn =
          GoogleSignIn(scopes: ['https://www.googleapis.com/auth/drive']);
      googleSignIn.signInSilently().whenComplete(() => () {});
    }

    //Get FCM Token
    String fcmToken = await _pushNotificationService.fcm.getToken();

    _user = new userModel.User(
      email: _firebaseUser.email,
      branch: branch,
      semester: semeseter,
      college: college,
      createdAt: DateTime.now().toString(),
      id: _firebaseUser.uid,
      isAuth: true,
      photoUrl: _firebaseUser.photoURL,
      username: _firebaseUser.displayName,
      fcmToken: fcmToken,
      // googleSignInAuthHeaders: await _googleUser.authHeaders,
    );
    if (isAdmin) {
      _user.setAdmin = true;
    }

    //Add User to Firebase
    await _firestoreService.saveUser(_user);

    //Add User To Local Storage
    SharedPreferencesService _sharedPreferencesService =
        locator<SharedPreferencesService>();
    await _sharedPreferencesService.saveUserLocally(_user);

    // Add this event Analytics
    await _addEventInfo(_user);

    if (_firebaseUser != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> handleSignOut() async {
    try {
      User user = await FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseAuth.instance.signOut();
        await googleSignIn.disconnect();
        await googleSignIn.signOut().catchError((e) {
          return false;
        });
      }
      SharedPreferencesService _sharedPreferencesService =
          locator<SharedPreferencesService>();
      userModel.User userr = userModel.User(isAuth: false);
      await _sharedPreferencesService.saveUserLocally(userr);
      //Store in state
      _user = userr;
      return true;
    } catch (e) {
      log.e("Something went wrong while logging out ${e.toString()}");
      return false;
    }

  }

  // *For Admins
  refreshSignInCredentials() async {
    googleSignIn = GoogleSignIn(scopes: [
      'https://www.googleapis.com/auth/drive.file',
      'https://www.googleapis.com/auth/drive',
      'https://www.googleapis.com/auth/drive.file',
      'https://www.googleapis.com/auth/drive.metadata'
    ]);
    GoogleSignInAccount ga = await googleSignIn.signIn();
    return ga.authHeaders;
  }

  refreshtoken() async {
    final GoogleSignInAccount googleSignInAccount =
        await googleSignIn.signInSilently();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    await firebaseAuth.signInWithCredential(credential);

    return googleSignInAccount.authHeaders; //new token
  }

   getUser() async {
    if (_user == null) {
      SharedPreferencesService _sharedPreferencesService =
          locator<SharedPreferencesService>();
      userModel.User user = await _sharedPreferencesService.getUser();
      return user;
    } else {
      return _user;
    }
  }

  _addEventInfo(user) async {
    // User Property in firebase
    String college = _user.college;
    if (college.length > 34) {
      college = college.substring(0, 34);
    }
    _analyticsService.setUserProperty(name: 'college', value: college);
    _analyticsService.setUserProperty(name: 'branch', value: _user.branch);
    _analyticsService.setUserProperty(name: 'semester', value: _user.semester);
    _analyticsService.setUserProperty(name: 'email', value: _user.email);
    _analyticsService.setUserProperty(name: 'username', value: _user.username);
    _analyticsService.analytics.setUserId(_user.id);
    bool shouldSubscribe = await _askForPermissionToSubscribeToFcmTopic();
    if (shouldSubscribe ?? false) {
    //*Present fcm topics user wants to subscribe
      var user_semester = CourseInfo.semesterToNumber[_user.semester];
      var user_branch = _user.branch;
      var user_college = CourseInfo.collegeToShortFrom[_user.college];
      _pushNotificationService.fcm.subscribeToTopic(user_semester);
      _pushNotificationService.fcm.subscribeToTopic(user_branch);
      _pushNotificationService.fcm.subscribeToTopic(user_college);
    // Check for previously subscribed fcm topics and unsubscribe user from them
    //* Past fcm topics user had subscribed
      var fcm_semester = OnboardingService.box.get("fcm_semester");
      var fcm_branch = OnboardingService.box.get("fcm_branch");
      var fcm_college = OnboardingService.box.get("fcm_college");
      _pushNotificationService.handleFcmTopicUnSubscription(
          fcm_semester,
          fcm_branch,
          fcm_college,
          user_semester,
          user_branch,
          user_college,
          _user.fcmToken);
      //Save these locally to ensure that topics subscribed can be tracked and unsubscribed later
      OnboardingService.box.put("fcm_semester", user_semester);
      OnboardingService.box.put("fcm_branch", user_branch);
      OnboardingService.box.put("fcm_college", user_college);
    }
    Map<String, dynamic> tags = {
      "college": _user.college,
      "branch": _user.branch,
      "semester": _user.semester,
      "email": _user.email,
      "username": _user.username,
    };
    OneSignal.shared.sendTags(tags);
    OneSignal.shared.setEmail(email: _user.email);
    OneSignal.shared.setExternalUserId(_user.id);
  }

  void _handleAuthError(var e) {
    log.e("ERROR AUTHENTICATING : ${e.toString()}");
    _bottomSheetService.showBottomSheet(
        title: "Oops !",
        description:
            "We've had trouble logging in, please try again or share a screenshot with us at ounotesplatform@gmail.com to solve this issue. ${e.toString()}");
  }

  Future<bool> _askForPermissionToSubscribeToFcmTopic() async {
    bool didUserAnswer = false;
    SheetResponse response;
    while (!didUserAnswer) {
      response = await _bottomSheetService.showCustomSheet(
          variant: BottomSheetType.filledStacks,
          title: Strings.fcm_token_permission_title,
          description: Strings.fcm_token_permission_description,
          secondaryButtonTitle: Strings.fcm_token_permission_secondary_button,
          mainButtonTitle: Strings.fcm_token_permission_main_button);
      didUserAnswer = response != null;
    }
    return response?.confirmed;
  }
}
