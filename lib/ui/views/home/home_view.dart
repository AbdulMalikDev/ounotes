import 'package:FSOUNotes/app/app.logger.dart';
import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/misc/helper.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:FSOUNotes/ui/views/home/home_viewmodel.dart';
import 'package:FSOUNotes/ui/views/search/search_view.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/no_subjects_overlay.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/user_subject_list/user_subject_list_view.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:stacked/stacked.dart';

Logger log = getLogger("HomeView");

class HomeView extends StatefulWidget {
  final bool shouldShowUpdateDialog;
  final Map<String, dynamic> versionDetails;
  const HomeView({Key key, this.shouldShowUpdateDialog, this.versionDetails})
      : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    double hp = App(context).appHeight(1);
    double wp = App(context).appWidth(1);
    return ViewModelBuilder<HomeViewModel>.reactive(
      onModelReady: (model) async {
        // await model.admobService.hideNotesViewBanner();
        model.showRateMyAppDialog(context);
        model.updateDialog(
            widget.shouldShowUpdateDialog, widget.versionDetails);
        model.showIntroDialog(context);
        // model.showTelgramDialog(context);
      },
      builder: (context, homeViewModel, child) => Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: SizedBox(
                    height: hp * 0.07,
                    width: wp * 0.6,
                    child: TextField(
                      onTap: () {
                        showSearch(
                          context: context,
                          delegate: SearchView(path: Path.Appbar),
                        );
                      },
                      readOnly: true,
                      decoration: InputDecoration(
                        fillColor: Theme.of(context).colorScheme.background,
                        filled: true,
                        hintText: "Search Subject",
                        hintStyle: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: hp * 0.015,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 18,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(05),
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                      style: Theme.of(context).textTheme.headline5,
                      onChanged: (value) {},
                    ),
                  ),
                ),
                Flexible(
                  child: Center(
                    child: Container(
                      width: wp * 0.35,
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.amber,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Text(
                                "UPLOAD",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.upload_file_rounded,
                            ),
                          ],
                        ),
                        onPressed: () {
                          homeViewModel.navigateToUserUploadScreen();
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(left: 15),
                child: Text(
                  "🔁 Study These Again",
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 10),
                child: TextButton(
                  child: Text("See All"),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          homeViewModel.isEditPressed
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        IconButton(
                          onPressed: () {
                            homeViewModel.setIsEditPressed = false;
                          },
                          icon: Icon(Icons.close),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: ValueListenableBuilder(
                            valueListenable: homeViewModel.userSelectedSubjects,
                            builder: (context, userSelectedSubjects, child) {
                              return Text(
                                "${userSelectedSubjects.length} Selected",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(fontWeight: FontWeight.bold),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      onPressed: () {
                        print('delete pressed');
                        Helper.showDeleteConfirmDialog(
                          context: context,
                          onDeletePressed: () {
                            homeViewModel.setIsEditPressed = false;
                            Navigator.pop(context);
                            homeViewModel.deleteSelectedSubjects();
                          },
                          msg:
                              "Are you sure you want to delete these subjects?",
                        );
                      },
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        "📝 My Subjects",
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        MdiIcons.pencil,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      onPressed: () {
                        homeViewModel.setIsEditPressed = true;
                      },
                    ),
                  ],
                ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: homeViewModel.userSubjects,
              builder: (context, userSubjects, child) {
                return homeViewModel.userSubjects.value.length == 0
                    ? NoSubjectsOverlay()
                    : UserSubjectListView(
                        isEditPressed: homeViewModel.isEditPressed,
                      );
              },
            ),
          ),
        ],
      ),
      viewModelBuilder: () => HomeViewModel(),
    );
  }
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
//
//  ga.File fileMetadata = ga.File();
// fileMetadata.name = "ounotes";
// fileMetadata.mimeType = "application/vnd.google-apps.folder";
// var responsed = await drive.files.create(fileMetadata);
// print("response file id: ${responsed.id}");

// ga.File fileMetadataq = ga.File();
// fileMetadataq.name = "something";
// fileMetadataq.mimeType = "application/vnd.google-apps.folder";
// fileMetadataq.parents = ["${responsed.id}"];
// var responsedq = await drive.files.create(fileMetadata);
// print("response file id: ${responsedq.id}");
// // print("s");
// var PDF_FOLDER = await drive.files.create(
//                 ga.File()
//                   ..name = "PDFs_NEW"
//                 // Optional if you want to create subfolder
//                   ..mimeType = 'application/vnd.google-apps.folder',  // this defines its folder
//               );
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

//file downloaded
//    //TODO STEP 2 UPLOAD IT ON GOOGLE DRIVE
//Make new GDrive file
//       ga.File fileToUpload = ga.File();
//Add new contents
//       fileToUpload.name = note.title;
//       fileToUpload.copyRequiresWriterPermission = true;
//       fileToUpload.parents = [subject.gdriveNotesFolderID];
//upload to drive
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
