import 'dart:io';

import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/ui/views/home/home_viewmodel.dart';
import 'package:FSOUNotes/ui/views/search/search_view.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/no_subjects_overlay.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/drawer/drawer_view.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/subjects_dialog/subjects_dialog_view.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/user_subject_list/user_subject_list_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return ViewModelBuilder<HomeViewModel>.reactive(
      onModelReady: (model) => model.showIntroDialog(),
      builder: (context, model, child) => WillPopScope(
        onWillPop: () => showDialog<bool>(
          context: context,
          builder: (c) => AlertDialog(
            backgroundColor: theme.scaffoldBackgroundColor,
            content: Text('Are you sure you want to quit OU Notes',
                style: theme.textTheme.subtitle1.copyWith(fontSize: 17)),
            actions: [
              FlatButton(
                child: Text('No',
                    style: theme.textTheme.subtitle1.copyWith(fontSize: 17)),
                onPressed: () => Navigator.pop(c, false),
              ),
              FlatButton(
                child: Text('Yes',
                    style: theme.textTheme.subtitle1.copyWith(fontSize: 17)),
                onPressed: () => exit(0),
              ),
            ],
          ),
        ),
        child: Scaffold(
          drawer: DrawerView(),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
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
                return Column(
                  children: [
                    model.userSubjects.value.length == 0
                        ? NoSubjectsOverlay()
                        : UserSubjectListView(),
                  ],
                );
              }),

          //drawer: GetDrawer(),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: FloatingActionButton(
              onPressed: () {
                Fluttertoast.showToast(msg: 'Add Subjects');
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SubjectsDialogView();
                    });
              },
              child: const Icon(Icons.add),
              backgroundColor: Theme.of(context).accentColor,
            ),
          ),
        ),
      ),
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}












































// import 'dart:io';

// import 'package:FSOUNotes/enums/constants.dart';
// import 'package:FSOUNotes/enums/enums.dart';
// import 'package:FSOUNotes/models/notes.dart';
// import 'package:FSOUNotes/models/subject.dart';
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
//       onModelReady: (model) => model.showIntroDialog(),
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
//                 // _listGoogleDriveFiles();
//                 _uploadFileToGoogleDrive(model:model);

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
//        googleSignIn.signInSilently().whenComplete(() => () {});  
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
//    print("DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDd");
//    var client = GoogleHttpClient(await googleSignInAccount.authHeaders);  
//    var drive = ga.DriveApi(client);
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
// //   var PDF_FOLDER = await drive.files.create(
// //                   ga.File()
// //                     ..name = "PDFs"
// //                   // Optional if you want to create subfolder
// //                     ..mimeType = 'application/vnd.google-apps.folder',  // this defines its folder
// //                 );
                
//   List<Subject> allSubjects = model.allSubjects.value;
//   print(allSubjects.length);
  
//   for (var subject in allSubjects) {
//     print(subject.name);

//     List<Note> notes = await model.getNotesFromFirebase(subject);
//     print(notes);
//     NotesViewModel notesViewModel = NotesViewModel();

//     for ( var note in notes)
//     {
//       ga.File fileToUpload = ga.File();  
//       //  var file = await FilePicker.getFile();  
//       File file = await notesViewModel.downloadFile(note: note , notesName: note.title , subName: note.subjectName , type: Constants.notes);
//       print(file.path);
//       print(file.uri);
//       fileToUpload.parents = [subject.gdriveNotesFolderID];  
//       fileToUpload.name = note.title; 
//       print("Uploading file..........."); 
//       var response = await drive.files.create(  
//         fileToUpload, 
//         uploadMedia: ga.Media(file.openRead(), file.lengthSync()),  
//       );
//       String GDrive_URL = "https://drive.google.com/file/d/${response.id}/view?usp=sharing";  
//       print(GDrive_URL);
//       note.setGdriveDownloadLink(GDrive_URL);
//       print(note.toJson());
//       model.updateNoteInFirebase(note);

//       await Future.delayed(Duration(seconds: 1),(){});
//     }


//     await Future.delayed(Duration(seconds: 2),(){});

//     // model.addSubjectToFirebase(subject);

    
    
//   }
//   // allSubjects.forEach((subject) async { 

//   // });

//   // var subjectFolder = await drive.files.create(
//   //                 ga.File()
//   //                   ..name = subject.name
//   //                   ..parents = [PDF_FOLDER.id]// Optional if you want to create subfolder
//   //                   ..mimeType = 'application/vnd.google-apps.folder',  // this defines its folder
//   //               );
//   //   var notesFolder = await drive.files.create(
//   //                 ga.File()
//   //                   ..name = 'NOTES'
//   //                   ..parents = [subjectFolder.id]// Optional if you want to create subfolder
//   //                   ..mimeType = 'application/vnd.google-apps.folder',  // this defines its folder
//   //               );

//   //   subject.addFolderID(subjectFolder.id);
//   //   subject.addNotesFolderID(notesFolder.id);


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
//  } 

//  Future<void> _listGoogleDriveFiles() async {  
//    var client = GoogleHttpClient(await googleSignInAccount.authHeaders);  
//    var drive = ga.DriveApi(client);  
//    drive.files.list(spaces: 'drive').then((value) {  
//      setState(() {  
//        list = value;  
//      });  
//      for (var i = 0; i < list.files.length; i++) {  
//        print("Id: ${list.files[i].id} File Name:${list.files[i].name}");  
//      }  
//    });  
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

