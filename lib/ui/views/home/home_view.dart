import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/misc/course_info.dart';
import 'package:FSOUNotes/misc/helper.dart';
import 'package:FSOUNotes/models/subject.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
import 'package:FSOUNotes/services/funtional_services/firestore_service.dart';
import 'package:FSOUNotes/services/funtional_services/google_drive_service.dart';
import 'package:FSOUNotes/services/funtional_services/onboarding_service.dart';
import 'package:FSOUNotes/ui/views/home/home_viewmodel.dart';
import 'package:FSOUNotes/ui/views/search/search_view.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/no_subjects_overlay.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/drawer/drawer_view.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/subjects_dialog/subjects_dialog_view.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/user_subject_list/user_subject_list_view.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:logger/logger.dart';
import 'package:pimp_my_button/pimp_my_button.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:stacked/stacked.dart';
Logger log = getLogger("HomeView");

class HomeView extends StatelessWidget {
  final bool shouldShowUpdateDialog;
  final Map<String, dynamic> versionDetails;
  const HomeView({Key key, this.shouldShowUpdateDialog, this.versionDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return ViewModelBuilder<HomeViewModel>.reactive(
      onModelReady: (model) async {
        // await model.admobService.hideNotesViewBanner();
        model.showRateMyAppDialog(context);
        model.updateDialog(shouldShowUpdateDialog, versionDetails);
        model.showIntroDialog(context);
      },
      builder: (context, model, child) => WillPopScope(
        onWillPop: () => Helper.showWillPopDialog(context: context),
        child: RateMyAppBuilder(
          builder: (context) => Scaffold(
            drawer: DrawerView(),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              leading: Builder(builder: (BuildContext context) {
                return DescribedFeatureOverlay(
                  featureId: OnboardingService
                      .drawer_hamburger_icon_to_access_other_features, // Unique id that identifies this overlay.
                  tapTarget: const Icon(Icons
                      .menu), // The widget that will be displayed as the tap target.
                  title: Text('Drawer'),
                  description: Text('Find cool new features in the drawer'),
                  backgroundColor: Theme.of(context).primaryColor,
                  targetColor: Colors.white,
                  textColor: Colors.white,
                  onComplete: () {
                    Scaffold.of(context).openDrawer();
                    return Future.value(true);
                  },
                  child: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                );
              }),
              iconTheme: IconThemeData(
                color: Colors.white, //change your color here
              ),
              title: Text(
                'My Subjects',
                style: theme.appBarTheme.textTheme.headline6,
              ),
              backgroundColor: theme.appBarTheme.color,
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    showSearch(
                        context: context,
                        delegate: SearchView(path: Path.Appbar));
                  },
                ),
              ],
            ),
            body: ValueListenableBuilder(
              valueListenable: model.userSubjects,
              builder: (context, userSubjects, child) {
                return model.userSubjects.value.length == 0
                    ? NoSubjectsOverlay()
                    : UserSubjectListView();
              },
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: DescribedFeatureOverlay(
                featureId: OnboardingService
                    .floating_action_button_to_add_subjects, // Unique id that identifies this overlay.
                tapTarget: const Icon(Icons
                    .add), // The widget that will be displayed as the tap target.
                title: Text('Add Your Subjects !'),
                description: Text(
                    'Please use \"+\" button to add subjects and swipe left or right to delete them'),
                backgroundColor: Theme.of(context).primaryColor,
                targetColor: Theme.of(context).accentColor,
                textColor: Colors.white,
                child: PimpedButton(
                  particle: DemoParticle(),
                  pimpedWidgetBuilder: (context, controller) {
                    return FloatingActionButton(
                      onPressed: () async {
                        controller.forward(from: 0.4);
                        await Future.delayed(Duration(milliseconds: 290));
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (BuildContext context) =>
                                SubjectsDialogView());
                      },
                      child: const Icon(Icons.add),
                      backgroundColor: Theme.of(context).accentColor,
                    );
                  },
                ),
              ),
            ),
          ),
          onInitialized: (context, rateMyApp) {
            
          },
        ),
      ),
      viewModelBuilder: () => HomeViewModel(),
    );
  }
  // FirestoreService _firestore = locator<FirestoreService>();
  // print("start");
  // List<int> ids = [];
  // List<Subject> mainSubs = [];
  // List<Subject> commentedOut = [];
  // try {
  //   CourseInfo.aallsubjects.forEach((sub)=>ids.add(sub.id));
  //   for(int i=1 ; i<=378 ; i++){
  //     if(ids.contains(i)){
  //       Subject mainSub = CourseInfo.aallsubjects.firstWhere((sub)=>sub.id==i,orElse: ()=>null); 
  //       if(mainSub!=null)mainSubs.add(mainSub);
  //     }else{
  //       Subject commentedOutSub = CourseInfo.allOldSubjects.firstWhere((sub)=>sub.id==i,orElse: ()=>null); 
  //       if(commentedOutSub!=null)commentedOut.add(commentedOutSub);
  //     }
  //   }
  // } catch (e) {
  //   print(e.toString());
  // }
  // List mainNames = mainSubs.map((e) => e.name).toSet().toList();
  // mainNames.sort((b,c)=>b.compareTo(c));
  // List commentedOutNames = commentedOut.map((e) => e.name).toSet().toList();
  // commentedOutNames.sort((b,c)=>b.compareTo(c));
  // // commentedOutNames.forEach((element) {print(element);});
  // // print();
  // // print(a.length);
  // print("Main Subjects : " + mainNames.length.toString());
  // print("\n");
  // print("Commented Out Subjects : " + commentedOut.length.toString());
  // List<Subject> duplicateSubject = []; 
  // commentedOutNames.forEach((commentedOutName){
  //   bool dupExist = mainNames.contains(commentedOutName);
  //   if(dupExist){
  //     //Found duplicateSubject that needs to be deleted rightaway
  //     Subject currentSub = CourseInfo.aallsubjects.firstWhere((sub)=>sub.name==commentedOutName,orElse: ()=>null);
  //     if(currentSub!=null)duplicateSubject.add(currentSub);
  //     // print(currentSub?.name);
  //   }
  // });
  // print("Duplicate Subjects : " + duplicateSubject.length.toString());
  // List<String> duplicateSubjectNames = duplicateSubject.map((e) => e.name).toList();
  // print(duplicateSubjectNames);
  // //Duplicate subjects already handled so need of any deletion, 
  // //only need of new subject upload + delete of useless ones
  // //* There are 378 subjects
  // try {
  //   for( int i=1 ; i<379 ; i++){
      
  //     // There is a subject linked to each number
  //     // It is either to be deleted or updated
  //     if(ids.contains(i)){
  //         Subject currentSub = CourseInfo.aallsubjects.firstWhere((sub)=>sub.id==i,orElse: ()=>null);
  //         if(duplicateSubjectNames.contains(currentSub.name)){
  //           //DO NOTHING SINCE ALREADY HANDLED
  //           continue;
  //         }
  //         //The subject is in the main list so upload it
  //         //UPLOAD
  //         //TODO ADD SUBJECT TO FIREBASE AS WELL AS RUN CODE IN GDRIVE TO ADD 4 FOLDERS [VERIFIED]
  //         await _addCompleteSubject(currentSub,_firestore);
  //         print("Upload : " + currentSub.name);
  //     }else{
  //       Subject currentSub = CourseInfo.allOldSubjects.firstWhere((sub)=>sub.id==i,orElse: ()=>null);
  //       if(currentSub==null)continue;
  //       //If subject is duplicate simply ignore
  //       if(duplicateSubjectNames.contains(currentSub.name)){
  //         //DO NOTHING SINCE ALREADY HANDLED
  //         continue;
  //       }else{
  //         //DELETE WITH ALL NOTES
  //         print("Delete : " + currentSub.name);
  //         _deleteExistenceOfSubject(currentSub.name,_firestore,i);
  //       }
  //     }
  //   }
  // }catch (e) {
  //         print(e.toString());                  
  // }

  // void _deleteExistenceOfSubject(String subjectName,FirestoreService _firestore,int id) async {
  //   bool result = await _firestore.destroySubject(subjectName, id);
  //   log.e("DESTROYED");
  //   log.e("SubjectName : " + subjectName);
  //   log.e("Result : " + result.toString());
  // }

  // void _addCompleteSubject(Subject subject,FirestoreService _firestore) async {
  //   // bool should_make_new_files = CourseInfo.allOldSubjects.any((element) => element.name == subject.name);
  //   // if(!should_make_new_files){
  //   subject = await _makeNewSubject(subject);
  //   await _firestore.addSubject(subject);
  // }

  // Future<Subject> _makeNewSubject(Subject subject) async {
  //   // DriveApi.DriveAppdataScope
  //       AuthenticationService _authenticationService = locator<AuthenticationService>();
  //       var AuthHeaders = await _authenticationService.refreshSignInCredentials();
  //       var client = GoogleHttpClient(AuthHeaders);
  //       var drive = ga.DriveApi(client);
  //       var subjectFolder = await drive.files.create(
  //                     ga.File()
  //                       ..name = subject.name
  //                       ..parents = ["10z-Uogzkp9ifd8wDzV1gGOgnqGPDKmsR"]// Optional if you want to create subfolder
  //                       ..mimeType = 'application/vnd.google-apps.folder',  // this defines its folder
  //                   );
  //       var notesFolder = await drive.files.create(
  //                     ga.File()
  //                       ..name = 'NOTES'
  //                       ..parents = [subjectFolder.id]// Optional if you want to create subfolder
  //                       ..mimeType = 'application/vnd.google-apps.folder',  // this defines its folder
  //                   );
  //       var questionPapersFolder = await drive.files.create(
  //                     ga.File()
  //                       ..name = 'QUESTION PAPERS'
  //                       ..parents = [subjectFolder.id]// Optional if you want to create subfolder
  //                       ..mimeType = 'application/vnd.google-apps.folder',  // this defines its folder
  //                   );
  //       var syllabusFolder = await drive.files.create(
  //                     ga.File()
  //                       ..name = 'SYLLABUS'
  //                       ..parents = [subjectFolder.id]// Optional if you want to create subfolder
  //                       ..mimeType = 'application/vnd.google-apps.folder',  // this defines its folder
  //                   );

  //       subject.addFolderID(subjectFolder.id);
  //       subject.addNotesFolderID(notesFolder.id);
  //       subject.addQuestionPapersFolderID(questionPapersFolder.id);
  //       subject.addSyllabusFolderID(syllabusFolder.id);
  //       log.e(subjectFolder.id);
  //       log.e(notesFolder.id);
  //       log.e(questionPapersFolder.id);
  //       log.e(syllabusFolder.id);
  //       return subject;
  // }
}

// import 'dart:io';

// import 'package:FSOUNotes/app/locator.dart';
// import 'package:FSOUNotes/enums/constants.dart';
// import 'package:FSOUNotes/enums/enums.dart';
// import 'package:FSOUNotes/models/notes.dart';
// import 'package:FSOUNotes/models/question_paper.dart';
// import 'package:FSOUNotes/models/subject.dart';
// import 'package:FSOUNotes/models/syllabus.dart';
// import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
// import 'package:FSOUNotes/ui/views/home/home_viewmodel.dart';
// import 'package:FSOUNotes/ui/views/notes/notes_viewmodel.dart';
// import 'package:FSOUNotes/ui/views/search/search_view.dart';
// import 'package:FSOUNotes/ui/widgets/dumb_widgets/no_subjects_overlay.dart';
// import 'package:FSOUNotes/ui/widgets/smart_widgets/drawer/drawer_view.dart';
// import 'package:FSOUNotes/ui/widgets/smart_widgets/subjects_dialog/subjects_dialog_view.dart';
// import 'package:FSOUNotes/ui/widgets/smart_widgets/user_subject_list/user_subject_list_view.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:googleapis/drive/v3.dart' as ga;
// import 'package:http/http.dart' as http;
// import 'package:path/path.dart' as path;
// import 'package:http/io_client.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:stacked/stacked.dart';

// class HomeView extends StatefulWidget {
//   const HomeView({Key key}) : super(key: key);

//   @override
//   _HomeViewState createState() => _HomeViewState();
// }

// class _HomeViewState extends State<HomeView> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final storage = new FlutterSecureStorage();
//    final GoogleSignIn googleSignIn =
//       GoogleSignIn(scopes: ['https://www.googleapis.com/auth/drive']);
//   GoogleSignInAccount googleSignInAccount;
//   ga.FileList list;
//   var signedIn = false;
//   @override
//   Widget build(BuildContext context) {
//     var theme = Theme.of(context);
//     return ViewModelBuilder<HomeViewModel>.reactive(
//       onModelReady: (model) => model.showIntroDialog(context),
//       builder: (context, model, child) => WillPopScope(
//         onWillPop: () => showDialog<bool>(
//           context: context,
//           builder: (c) => AlertDialog(
//             backgroundColor: theme.scaffoldBackgroundColor,
//             content: Text('Are you sure you want to quit OU Notes',
//                 style: theme.textTheme.subtitle1.copyWith(fontSize: 17)),
//             actions: [
//               FlatButton(
//                 child: Text('No',
//                     style: theme.textTheme.subtitle1.copyWith(fontSize: 17)),
//                 onPressed: () => Navigator.pop(c, false),
//               ),
//               FlatButton(
//                 child: Text('Yes',
//                     style: theme.textTheme.subtitle1.copyWith(fontSize: 17)),
//                 onPressed: () => exit(0),
//               ),
//             ],
//           ),
//         ),
//         child: Scaffold(
//           drawer: DrawerView(),
//           backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//           appBar: AppBar(
//             iconTheme: IconThemeData(
//               color: Colors.white, //change your color here
//             ),
//             title: Text(
//               'My Subjects',
//               style: theme.appBarTheme.textTheme.headline6,
//             ),
//             backgroundColor: theme.appBarTheme.color,
//             actions: <Widget>[
//               IconButton(
//                 icon: Icon(
//                   Icons.search,
//                   color: Colors.white,
//                 ),
//                 onPressed: () {
//                   showSearch(
//                       context: context,
//                       delegate: SearchView(path: Path.Appbar));
//                 },
//               ),
//             ],
//           ),

//           body: ValueListenableBuilder(
//               valueListenable: model.userSubjects,
//               builder: (context, userSubjects, child) {
//                 return Column(
//                   children: [
//                     model.userSubjects.value.length == 0
//                         ? NoSubjectsOverlay()
//                         : UserSubjectListView(),
//                   ],
//                 );
//               }),

//           //drawer: GetDrawer(),
//           floatingActionButton: Padding(
//             padding: const EdgeInsets.only(bottom: 20.0),
//             child: FloatingActionButton(
//               onPressed: () async {
//                 // Fluttertoast.showToast(msg: 'Add Subjects');
//                 // showDialog(
//                 //     context: context,
//                 //     builder: (BuildContext context) {
//                 //       return SubjectsDialogView();
//                 //     });
//                 await _loginWithGoogle();
//                 // _uploadFileToGoogleDrive();
//                 // await _listGoogleDriveFiles();
//                 _uploadFileToGoogleDrive(model:model);
//                 // _downloadGoogleDriveFile(model:model);

//               },
//               child: const Icon(Icons.add),
//               backgroundColor: Theme.of(context).accentColor,
//             ),
//           ),
//         ),
//       ),
//       viewModelBuilder: () => HomeViewModel(),
//     );
//   }

//   Future<void> _loginWithGoogle() async {
//    signedIn = await storage.read(key: "signedIn") == "true" ? true : false;
//    googleSignIn.onCurrentUserChanged
//        .listen((GoogleSignInAccount googleSignInAccount) async {
//      if (googleSignInAccount != null) {
//        _afterGoogleLogin(googleSignInAccount);
//      }
//    });
//    if (signedIn) {
//      try {
//        googleSignIn.signIn().whenComplete(() => () {});
//      } catch (e) {
//        storage.write(key: "signedIn", value: "false").then((value) {
//          setState(() {
//            signedIn = false;
//          });
//        });
//      }
//    } else {
//      googleSignInAccount =
//          await googleSignIn.signIn();
//      _afterGoogleLogin(googleSignInAccount);
//    }
//  }

//  _uploadFileToGoogleDrive({HomeViewModel model}) async {
//    print("LET'S START BOIS");
//    AuthenticationService _authenticationService = locator<AuthenticationService>();
//    var AuthHeaders = await _authenticationService.refreshSignInCredentials();
//    var client = GoogleHttpClient(AuthHeaders);
//    var drive = ga.DriveApi(client);
//   //
//   //  ga.File fileMetadata = ga.File();
//   // fileMetadata.name = "ounotes";
//   // fileMetadata.mimeType = "application/vnd.google-apps.folder";
//   // var responsed = await drive.files.create(fileMetadata);
//   // print("response file id: ${responsed.id}");

//   // ga.File fileMetadataq = ga.File();
//   // fileMetadataq.name = "something";
//   // fileMetadataq.mimeType = "application/vnd.google-apps.folder";
//   // fileMetadataq.parents = ["${responsed.id}"];
//   // var responsedq = await drive.files.create(fileMetadata);
//   // print("response file id: ${responsedq.id}");
// // // print("s");
//   // var PDF_FOLDER = await drive.files.create(
//   //                 ga.File()
//   //                   ..name = "PDFs_NEW"
//   //                 // Optional if you want to create subfolder
//   //                   ..mimeType = 'application/vnd.google-apps.folder',  // this defines its folder
//   //               );
//   print("Getting all subjects....");
//   List<Subject> allSubjects = model.allSubjects.value;
//   allSubjects.sort((a,b)=>a.name.compareTo(b.name));
//   print(allSubjects.length);
//   bool flag = false;
//   for (var subject in allSubjects) {

//     if (subject.name == "WEB PROGRAMMING"){
//       flag = true;
//     }
//     if (!flag){continue;}
//     print(subject.name);
//     print(subject.name == "WEB PROGRAMMING");
//     NotesViewModel notesViewModel = NotesViewModel();
//     // TODO CREATE SUBJECT FOLDER AND NOTES FOLDER INSIDE

//     var subjectFolder = await drive.files.create(
//                   ga.File()
//                     ..name = subject.name
//                     ..parents = ["13V7P7lLMo-uo2DohVFbJD8Q96V_dol_z"]// Optional if you want to create subfolder
//                     ..mimeType = 'application/vnd.google-apps.folder',  // this defines its folder
//                 );
//     var notesFolder = await drive.files.create(
//                   ga.File()
//                     ..name = 'NOTES'
//                     ..parents = [subjectFolder.id]// Optional if you want to create subfolder
//                     ..mimeType = 'application/vnd.google-apps.folder',  // this defines its folder
//                 );
//     var questionPapersFolder = await drive.files.create(
//                   ga.File()
//                     ..name = 'QUESTION PAPERS'
//                     ..parents = [subjectFolder.id]// Optional if you want to create subfolder
//                     ..mimeType = 'application/vnd.google-apps.folder',  // this defines its folder
//                 );
//     var syllabusFolder = await drive.files.create(
//                   ga.File()
//                     ..name = 'SYLLABUS'
//                     ..parents = [subjectFolder.id]// Optional if you want to create subfolder
//                     ..mimeType = 'application/vnd.google-apps.folder',  // this defines its folder
//                 );

//     subject.addFolderID(subjectFolder.id);
//     subject.addNotesFolderID(notesFolder.id);
//     subject.addQuestionPapersFolderID(questionPapersFolder.id);
//     subject.addSyllabusFolderID(syllabusFolder.id);

//     // TODO UPLOAD ALL NOTES OF THAT PARTICULAR SUBJECT
//     List<Note> notes = await model.getNotesFromFirebase(subject);
//     print(notes);

//     for ( Note note in notes)
//     {
//       //TODO STEP 1 DOWNLOAD NOTE FILE FROM GOOGLE DRIVE
//       //Extract File ID
//       if (note.GDriveLink == null){continue;}
//       String url = note.GDriveLink.split("https://drive.google.com/file/d/")[1];
//       String FileID = url.split("/view?usp=sharing")[0];
//       //download file
//       ga.Media file = await drive.files.get(FileID,downloadOptions: ga.DownloadOptions.FullMedia);
//       // write this file to local first
//       File localFile;
//       //TODO BAIGAN KA STORE KARO LOCALLY

//               var response = file;
//               Directory tempDir = await getTemporaryDirectory();
//               List<int> dataStore = [];
//                 response.stream.listen((data) {
//                 print("DataReceived: ${data.length}");
//                 dataStore.insertAll(dataStore.length, data);
//               }, onDone: () async {
//                   //Get temp folder using Path Provider
//                 String tempPath = tempDir.path;
//                   localFile = File('$tempPath/${new DateTime.now().millisecondsSinceEpoch}'); //Create a dummy file
//                   await localFile.writeAsBytes(dataStore);
//                   print("Task Done");

//       //file downloaded
//       //TODO STEP 2 UPLOAD IT ON GOOGLE DRIVE
//       //Make new GDrive file
//       ga.File fileToUpload = ga.File();
//       //Add new contents
//       fileToUpload.name = note.title;
//       fileToUpload.copyRequiresWriterPermission = true;
//       fileToUpload.parents = [subject.gdriveNotesFolderID];
//       //upload to drive
//       var response;
//       try {
//           response = await drive.files.create(
//           fileToUpload,
//           uploadMedia: ga.Media(localFile.openRead(), localFile.lengthSync()),
//         );
//       } on Exception catch (e) {
//               print(e.toString());
//       }
//       if (response!= null && response.id!=null) {
//         String GDrive_URL = "https://drive.google.com/file/d/${response.id}/view?usp=sharing";
//         print(GDrive_URL);
//         // save all info
//         note.setGdriveDownloadLink(GDrive_URL);
//         note.setGdriveID(response.id);
//         note.setGDriveNotesFolderID(notesFolder.id);
//         print(note.toJson());
//         model.updateNoteInFirebase(note);
//       }

//               }, onError: (error) {
//                 print("Some Error ${error.toString()}");
//               });
//       // await Future.delayed(Duration(seconds: 1),(){});
//     }

//     // await Future.delayed(Duration(seconds: 2),(){});

//     // TODO UPLOAD ALL QUESTION PAPERS OF THAT PARTICULAR SUBJECT
//     List<QuestionPaper> questionPapers = await model.getQuestionPapersFromFirebase(subject);
//     print(questionPapers);

//      for ( var paper in questionPapers)
//     {
//       ga.File fileToUpload = ga.File();
//       File file = await notesViewModel.downloadFile(notesName: paper.title , subName: paper.subjectName , type: Constants.questionPapers);
//       print(file.path);
//       print(file.uri);
//       fileToUpload.parents = [subject.gdriveQuestionPapersFolderID];
//       fileToUpload.name = paper.title;
//       fileToUpload.copyRequiresWriterPermission = true;
//       print("Uploading Question Paper");
//       var response;
//       try {
//           response = await drive.files.create(
//           fileToUpload,
//           uploadMedia: ga.Media(file.openRead(), file.lengthSync()),
//         );
//       } on Exception catch (e) {
//               print(e.toString());
//       }
//       if (response!= null && response.id!=null) {
//       String GDrive_URL = "https://drive.google.com/file/d/${response.id}/view?usp=sharing";
//       print(GDrive_URL);
//       paper.setGdriveDownloadLink(GDrive_URL);
//       paper.setGDriveQuestionPapersFolderID(subject.gdriveQuestionPapersFolderID);
//       paper.setGdriveID(response.id);
//       print(paper.toJson());
//       model.updateQuestionPaperInFirebase(paper);
//       }
//       // await Future.delayed(Duration(seconds: 1),(){});
//     }

//     // await Future.delayed(Duration(seconds: 2),(){});
//     // TODO UPLOAD ALL SYLLABUS OF THAT PARTICULAR SUBJECT
//     List<Syllabus> syllabus = await model.getSyllabusFromFirebase(subject);
//     print(syllabus);

//      for ( var syllab in syllabus)
//     {
//       ga.File fileToUpload = ga.File();
//       File file = await notesViewModel.downloadFile(notesName: syllab.title , subName: syllab.subjectName , type: Constants.syllabus);
//       print(file.path);
//       print(file.uri);
//       fileToUpload.parents = [subject.gdriveSyllabusFolderID];
//       fileToUpload.name = syllab.title;
//       fileToUpload.copyRequiresWriterPermission = true;
//       print("Uploading SYLLBUS BITCHES");
//       var response;
//       try {
//           response = await drive.files.create(
//           fileToUpload,
//           uploadMedia: ga.Media(file.openRead(), file.lengthSync()),
//         );
//       } on Exception catch (e) {
//               print(e.toString());
//       }
//       if (response!= null && response.id!=null) {
//       String GDrive_URL = "https://drive.google.com/file/d/${response.id}/view?usp=sharing";
//       print(GDrive_URL);
//       syllab.setGdriveDownloadLink(GDrive_URL);
//       syllab.setGDriveSyllabusFolderID(subject.gdriveQuestionPapersFolderID);
//       syllab.setGdriveID(response.id);
//       print(syllab.toJson());
//       model.updateSyllabusInFirebase(syllab);
//       }
//       // await Future.delayed(Duration(seconds: 1),(){});
//     }

//     // await Future.delayed(Duration(seconds: 2),(){});

//     // TODO UPDATE SUBJECT SINCE WE ADDED FOLDER LINKS
//     model.addSubjectToFirebase(subject);
//     print("subject added");
//   //  AuthHeaders = await _authenticationService.refreshtoken();
//   //  client = GoogleHttpClient(AuthHeaders);
//   //  drive = ga.DriveApi(client);

//   }
//  }
//   // allSubjects.forEach((subject) async {

//   // });

//   //  ga.File fileToUpload = ga.File();
//   //  var file = await FilePicker.getFile();
//   //  fileToUpload.parents = ["${notesFolder.id}"];
//   //  fileToUpload.name = path.basename(file.absolute.path);
//   //  print("UPloading file");

//   //  var response = await drive.files.create(
//   //    fileToUpload,
//   //    uploadMedia: ga.Media(file.openRead(), file.lengthSync()),
//   //  );
//   //  drive.files.
//   //  print(response);

// //  _getAFilePlease(response,file,tempDir)async {

// //  }

//  Future<void> _downloadGoogleDriveFile({HomeViewModel model}) async {
//   //  var client = GoogleHttpClient(await googleSignInAccount.authHeaders);
//   //  var drive = ga.DriveApi(client);
//   //  ga.Media file = await drive.files
//   //      .get(gdID, downloadOptions: ga.DownloadOptions.FullMedia);
//   //  print(file.stream);

//   //  final directory = await getExternalStorageDirectory();
//   //  print(directory.path);
//   //  final saveFile = File('${directory.path}/${new DateTime.now().millisecondsSinceEpoch}$fName');
//   //  List<int> dataStore = [];
//   //  file.stream.listen((data) {
//   //    print("DataReceived: ${data.length}");
//   //    dataStore.insertAll(dataStore.length, data);
//   //  }, onDone: () {
//   //    print("Task Done");
//   //    saveFile.writeAsBytes(dataStore);
//   //    print("File saved at ${saveFile.path}");
//   //  }, onError: (error) {
//   //    print("Some Error");
//   //  });
//  }

//  Future<void> _listGoogleDriveFiles() async {
//    var client = GoogleHttpClient(await googleSignInAccount.authHeaders);
//    var drive = ga.DriveApi(client);
//   //  drive.files.list(q: "mimeType = 'application/vnd.google-apps.folder'").then((value) {
//   //   //  setState(() {
//   //   //  });
//   //    list = value;
//   //    for (var i = 0; i < list.files.length; i++) {
//   //      print("Id: ${list.files[i].id} File Name:${list.files[i].name}");
//   //    }
//   //  });
//    ga.File resonse = await drive.files.get("1ec2t2jLDMyG3Kef-3BlS9ZnInBZbhxon");
//    print(resonse.id);
//  }

//  Future<void> _afterGoogleLogin(GoogleSignInAccount gSA) async {
//    var googleSignInAccount = gSA;
//    final GoogleSignInAuthentication googleSignInAuthentication =
//        await googleSignInAccount.authentication;

//    final AuthCredential credential = GoogleAuthProvider.getCredential(
//      accessToken: googleSignInAuthentication.accessToken,
//      idToken: googleSignInAuthentication.idToken,
//    );

//    final AuthResult authResult = await _auth.signInWithCredential(credential);
//    final FirebaseUser user = authResult.user;

//    assert(!user.isAnonymous);
//    assert(await user.getIdToken() != null);

//    final FirebaseUser currentUser = await _auth.currentUser();
//    assert(user.uid == currentUser.uid);

//    print('signInWithGoogle succeeded: $user');

//    storage.write(key: "signedIn", value: "true").then((value) {
//      setState(() {
//        signedIn = true;
//      });
//    });
//  }
// }
// class GoogleHttpClient extends IOClient {
//   Map<String, String> _headers;

//   GoogleHttpClient(this._headers) : super();

//   @override
//   Future<IOStreamedResponse> send(http.BaseRequest request) =>
//       super.send(request..headers.addAll(_headers));

//   @override
//   Future<http.Response> head(Object url, {Map<String, String> headers}) =>
//       super.head(url, headers: headers..addAll(_headers));
// }
