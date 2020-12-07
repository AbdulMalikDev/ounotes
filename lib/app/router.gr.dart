// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:FSOUNotes/ui/views/splash/spash_view.dart';
import 'package:FSOUNotes/ui/views/intro/intro_view.dart';
import 'package:FSOUNotes/ui/views/home/home_view.dart';
import 'package:FSOUNotes/ui/views/all_documents/all_documents_view.dart';
import 'package:FSOUNotes/ui/views/pdf/pdf_view.dart';
import 'package:FSOUNotes/ui/views/notes/notes_view.dart';
import 'package:FSOUNotes/ui/views/question_papers/question_papers_view.dart';
import 'package:FSOUNotes/ui/views/syllabus/syllabus_view.dart';
import 'package:FSOUNotes/ui/views/links/links_view.dart';
import 'package:FSOUNotes/ui/views/about_us/about_us_view.dart';
import 'package:FSOUNotes/ui/views/Profile/profile_view.dart';
import 'package:FSOUNotes/ui/views/upload/upload_view.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/ui/views/upload/upload_selection/upload_selection_view.dart';
import 'package:FSOUNotes/ui/views/downloads/Downloads_view.dart';
import 'package:FSOUNotes/ui/views/FilterDocuments/FD_InputScreen/fd_inputView.dart';
import 'package:FSOUNotes/ui/views/FilterDocuments/FD_subjectdisplay/fd_subjectview.dart';
import 'package:FSOUNotes/ui/views/FilterDocuments/FD_DocumentDisplay/fd_documentview.dart';
import 'package:FSOUNotes/ui/views/about_us/privacy_policy/privacy_policyview.dart';
import 'package:FSOUNotes/ui/views/about_us/privacy_policy/terms_and_conditionview.dart';
import 'package:FSOUNotes/ui/views/admin/admin_view.dart';
import 'package:FSOUNotes/ui/views/web_view/web_view.dart';
import 'package:FSOUNotes/models/notes.dart';
import 'package:FSOUNotes/models/question_paper.dart';
import 'package:FSOUNotes/models/syllabus.dart';
import 'package:FSOUNotes/ui/views/edit/edit_view.dart';

abstract class Routes {
  static const splashViewRoute = '/';
  static const introViewRoute = '/intro-view-route';
  static const homeViewRoute = '/home-view-route';
  static const allDocumentsViewRoute = '/all-documents-view-route';
  static const pdfScreenRoute = '/pdf-screen-route';
  static const notesViewRoute = '/notes-view-route';
  static const questionPapersViewRoute = '/question-papers-view-route';
  static const syllabusViewRoute = '/syllabus-view-route';
  static const linksViewRoute = '/links-view-route';
  static const aboutUsViewRoute = '/about-us-view-route';
  static const profileView = '/profile-view';
  static const uploadViewRoute = '/upload-view-route';
  static const uploadSelectionViewRoute = '/upload-selection-view-route';
  static const downLoadView = '/down-load-view';
  static const fdInputView = '/fd-input-view';
  static const fdSubjectView = '/fd-subject-view';
  static const fdDocumentView = '/fd-document-view';
  static const privacyPolicyView = '/privacy-policy-view';
  static const termsAndConditionView = '/terms-and-condition-view';
  static const adminViewRoute = '/admin-view-route';
  static const webViewWidgetRoute = '/web-view-widget-route';
  static const editViewRoute = '/edit-view-route';
  static const all = {
    splashViewRoute,
    introViewRoute,
    homeViewRoute,
    allDocumentsViewRoute,
    pdfScreenRoute,
    notesViewRoute,
    questionPapersViewRoute,
    syllabusViewRoute,
    linksViewRoute,
    aboutUsViewRoute,
    profileView,
    uploadViewRoute,
    uploadSelectionViewRoute,
    downLoadView,
    fdInputView,
    fdSubjectView,
    fdDocumentView,
    privacyPolicyView,
    termsAndConditionView,
    adminViewRoute,
    webViewWidgetRoute,
    editViewRoute,
  };
}

class Router extends RouterBase {
  @override
  Set<String> get allRoutes => Routes.all;

  @Deprecated('call ExtendedNavigator.ofRouter<Router>() directly')
  static ExtendedNavigatorState get navigator =>
      ExtendedNavigator.ofRouter<Router>();

  @override
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.splashViewRoute:
        return MaterialPageRoute<dynamic>(
          builder: (context) => SplashView(),
          settings: settings,
        );
      case Routes.introViewRoute:
        if (hasInvalidArgs<IntroViewArguments>(args)) {
          return misTypedArgsRoute<IntroViewArguments>(args);
        }
        final typedArgs = args as IntroViewArguments ?? IntroViewArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => IntroView(key: typedArgs.key),
          settings: settings,
        );
      case Routes.homeViewRoute:
        if (hasInvalidArgs<HomeViewArguments>(args)) {
          return misTypedArgsRoute<HomeViewArguments>(args);
        }
        final typedArgs = args as HomeViewArguments ?? HomeViewArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => HomeView(key: typedArgs.key),
          settings: settings,
        );
      case Routes.allDocumentsViewRoute:
        if (hasInvalidArgs<AllDocumentsViewArguments>(args, isRequired: true)) {
          return misTypedArgsRoute<AllDocumentsViewArguments>(args);
        }
        final typedArgs = args as AllDocumentsViewArguments;
        return MaterialPageRoute<dynamic>(
          builder: (context) => AllDocumentsView(
              subjectName: typedArgs.subjectName, path: typedArgs.path),
          settings: settings,
        );
      case Routes.pdfScreenRoute:
        if (hasInvalidArgs<PDFScreenArguments>(args)) {
          return misTypedArgsRoute<PDFScreenArguments>(args);
        }
        final typedArgs = args as PDFScreenArguments ?? PDFScreenArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) =>
              PDFScreen(pathPDF: typedArgs.pathPDF, title: typedArgs.title),
          settings: settings,
        );
      case Routes.notesViewRoute:
        if (hasInvalidArgs<NotesViewArguments>(args, isRequired: true)) {
          return misTypedArgsRoute<NotesViewArguments>(args);
        }
        final typedArgs = args as NotesViewArguments;
        return MaterialPageRoute<dynamic>(
          builder: (context) => NotesView(
              subjectName: typedArgs.subjectName,
              path: typedArgs.path,
              key: typedArgs.key),
          settings: settings,
        );
      case Routes.questionPapersViewRoute:
        if (hasInvalidArgs<QuestionPapersViewArguments>(args,
            isRequired: true)) {
          return misTypedArgsRoute<QuestionPapersViewArguments>(args);
        }
        final typedArgs = args as QuestionPapersViewArguments;
        return MaterialPageRoute<dynamic>(
          builder: (context) => QuestionPapersView(
              subjectName: typedArgs.subjectName,
              path: typedArgs.path,
              key: typedArgs.key),
          settings: settings,
        );
      case Routes.syllabusViewRoute:
        if (hasInvalidArgs<SyllabusViewArguments>(args, isRequired: true)) {
          return misTypedArgsRoute<SyllabusViewArguments>(args);
        }
        final typedArgs = args as SyllabusViewArguments;
        return MaterialPageRoute<dynamic>(
          builder: (context) => SyllabusView(
              subjectName: typedArgs.subjectName,
              path: typedArgs.path,
              key: typedArgs.key),
          settings: settings,
        );
      case Routes.linksViewRoute:
        if (hasInvalidArgs<LinksViewArguments>(args, isRequired: true)) {
          return misTypedArgsRoute<LinksViewArguments>(args);
        }
        final typedArgs = args as LinksViewArguments;
        return MaterialPageRoute<dynamic>(
          builder: (context) => LinksView(
              subjectName: typedArgs.subjectName,
              path: typedArgs.path,
              key: typedArgs.key),
          settings: settings,
        );
      case Routes.aboutUsViewRoute:
        if (hasInvalidArgs<AboutUsViewArguments>(args)) {
          return misTypedArgsRoute<AboutUsViewArguments>(args);
        }
        final typedArgs =
            args as AboutUsViewArguments ?? AboutUsViewArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => AboutUsView(key: typedArgs.key),
          settings: settings,
        );
      case Routes.profileView:
        if (hasInvalidArgs<ProfileViewArguments>(args)) {
          return misTypedArgsRoute<ProfileViewArguments>(args);
        }
        final typedArgs =
            args as ProfileViewArguments ?? ProfileViewArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => ProfileView(key: typedArgs.key),
          settings: settings,
        );
      case Routes.uploadViewRoute:
        if (hasInvalidArgs<UploadViewArguments>(args, isRequired: true)) {
          return misTypedArgsRoute<UploadViewArguments>(args);
        }
        final typedArgs = args as UploadViewArguments;
        return MaterialPageRoute<dynamic>(
          builder: (context) => UploadView(
              textFieldsMap: typedArgs.textFieldsMap,
              subjectName: typedArgs.subjectName,
              path: typedArgs.path,
              path2: typedArgs.path2),
          settings: settings,
        );
      case Routes.uploadSelectionViewRoute:
        if (hasInvalidArgs<UploadSelectionViewArguments>(args)) {
          return misTypedArgsRoute<UploadSelectionViewArguments>(args);
        }
        final typedArgs = args as UploadSelectionViewArguments ??
            UploadSelectionViewArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => UploadSelectionView(
              subjectName: typedArgs.subjectName, path: typedArgs.path),
          settings: settings,
        );
      case Routes.downLoadView:
        if (hasInvalidArgs<DownLoadViewArguments>(args)) {
          return misTypedArgsRoute<DownLoadViewArguments>(args);
        }
        final typedArgs =
            args as DownLoadViewArguments ?? DownLoadViewArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => DownLoadView(key: typedArgs.key),
          settings: settings,
        );
      case Routes.fdInputView:
        if (hasInvalidArgs<FDInputViewArguments>(args, isRequired: true)) {
          return misTypedArgsRoute<FDInputViewArguments>(args);
        }
        final typedArgs = args as FDInputViewArguments;
        return MaterialPageRoute<dynamic>(
          builder: (context) =>
              FDInputView(path: typedArgs.path, key: typedArgs.key),
          settings: settings,
        );
      case Routes.fdSubjectView:
        if (hasInvalidArgs<FDSubjectViewArguments>(args, isRequired: true)) {
          return misTypedArgsRoute<FDSubjectViewArguments>(args);
        }
        final typedArgs = args as FDSubjectViewArguments;
        return MaterialPageRoute<dynamic>(
          builder: (context) => FDSubjectView(
              sem: typedArgs.sem,
              br: typedArgs.br,
              path: typedArgs.path,
              key: typedArgs.key),
          settings: settings,
        );
      case Routes.fdDocumentView:
        if (hasInvalidArgs<FDDocumentViewArguments>(args, isRequired: true)) {
          return misTypedArgsRoute<FDDocumentViewArguments>(args);
        }
        final typedArgs = args as FDDocumentViewArguments;
        return MaterialPageRoute<dynamic>(
          builder: (context) => FDDocumentView(
              subjectName: typedArgs.subjectName,
              path: typedArgs.path,
              key: typedArgs.key),
          settings: settings,
        );
      case Routes.privacyPolicyView:
        if (hasInvalidArgs<PrivacyPolicyViewArguments>(args)) {
          return misTypedArgsRoute<PrivacyPolicyViewArguments>(args);
        }
        final typedArgs =
            args as PrivacyPolicyViewArguments ?? PrivacyPolicyViewArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => PrivacyPolicyView(key: typedArgs.key),
          settings: settings,
        );
      case Routes.termsAndConditionView:
        if (hasInvalidArgs<TermsAndConditionViewArguments>(args)) {
          return misTypedArgsRoute<TermsAndConditionViewArguments>(args);
        }
        final typedArgs = args as TermsAndConditionViewArguments ??
            TermsAndConditionViewArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => TermsAndConditionView(key: typedArgs.key),
          settings: settings,
        );
      case Routes.adminViewRoute:
        return MaterialPageRoute<dynamic>(
          builder: (context) => AdminView(),
          settings: settings,
        );
      case Routes.webViewWidgetRoute:
        if (hasInvalidArgs<WebViewWidgetArguments>(args)) {
          return misTypedArgsRoute<WebViewWidgetArguments>(args);
        }
        final typedArgs =
            args as WebViewWidgetArguments ?? WebViewWidgetArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => WebViewWidget(
              note: typedArgs.note,
              key: typedArgs.key,
              questionPaper: typedArgs.questionPaper,
              syllabus: typedArgs.syllabus,
              url: typedArgs.url),
          settings: settings,
        );
      case Routes.editViewRoute:
        if (hasInvalidArgs<EditViewArguments>(args, isRequired: true)) {
          return misTypedArgsRoute<EditViewArguments>(args);
        }
        final typedArgs = args as EditViewArguments;
        return MaterialPageRoute<dynamic>(
          builder: (context) => EditView(
              key: typedArgs.key,
              title: typedArgs.title,
              textFieldsMap: typedArgs.textFieldsMap,
              path: typedArgs.path,
              note: typedArgs.note,
              subjectName: typedArgs.subjectName),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}

// *************************************************************************
// Arguments holder classes
// **************************************************************************

//IntroView arguments holder class
class IntroViewArguments {
  final Key key;
  IntroViewArguments({this.key});
}

//HomeView arguments holder class
class HomeViewArguments {
  final Key key;
  HomeViewArguments({this.key});
}

//AllDocumentsView arguments holder class
class AllDocumentsViewArguments {
  final String subjectName;
  final String path;
  AllDocumentsViewArguments({@required this.subjectName, this.path});
}

//PDFScreen arguments holder class
class PDFScreenArguments {
  final String pathPDF;
  final String title;
  PDFScreenArguments({this.pathPDF, this.title});
}

//NotesView arguments holder class
class NotesViewArguments {
  final String subjectName;
  final String path;
  final Key key;
  NotesViewArguments({@required this.subjectName, this.path, this.key});
}

//QuestionPapersView arguments holder class
class QuestionPapersViewArguments {
  final String subjectName;
  final String path;
  final Key key;
  QuestionPapersViewArguments(
      {@required this.subjectName, this.path, this.key});
}

//SyllabusView arguments holder class
class SyllabusViewArguments {
  final String subjectName;
  final String path;
  final Key key;
  SyllabusViewArguments({@required this.subjectName, this.path, this.key});
}

//LinksView arguments holder class
class LinksViewArguments {
  final String subjectName;
  final String path;
  final Key key;
  LinksViewArguments({@required this.subjectName, this.path, this.key});
}

//AboutUsView arguments holder class
class AboutUsViewArguments {
  final Key key;
  AboutUsViewArguments({this.key});
}

//ProfileView arguments holder class
class ProfileViewArguments {
  final Key key;
  ProfileViewArguments({this.key});
}

//UploadView arguments holder class
class UploadViewArguments {
  final Map<dynamic, dynamic> textFieldsMap;
  final String subjectName;
  final Document path;
  final Document path2;
  UploadViewArguments(
      {this.textFieldsMap, @required this.subjectName, this.path, this.path2});
}

//UploadSelectionView arguments holder class
class UploadSelectionViewArguments {
  final String subjectName;
  final Document path;
  UploadSelectionViewArguments({this.subjectName, this.path});
}

//DownLoadView arguments holder class
class DownLoadViewArguments {
  final Key key;
  DownLoadViewArguments({this.key});
}

//FDInputView arguments holder class
class FDInputViewArguments {
  final Document path;
  final Key key;
  FDInputViewArguments({@required this.path, this.key});
}

//FDSubjectView arguments holder class
class FDSubjectViewArguments {
  final String sem;
  final String br;
  final Document path;
  final Key key;
  FDSubjectViewArguments(
      {@required this.sem, @required this.br, @required this.path, this.key});
}

//FDDocumentView arguments holder class
class FDDocumentViewArguments {
  final String subjectName;
  final Document path;
  final Key key;
  FDDocumentViewArguments({@required this.subjectName, this.path, this.key});
}

//PrivacyPolicyView arguments holder class
class PrivacyPolicyViewArguments {
  final Key key;
  PrivacyPolicyViewArguments({this.key});
}

//TermsAndConditionView arguments holder class
class TermsAndConditionViewArguments {
  final Key key;
  TermsAndConditionViewArguments({this.key});
}

//WebViewWidget arguments holder class
class WebViewWidgetArguments {
  final Note note;
  final Key key;
  final QuestionPaper questionPaper;
  final Syllabus syllabus;
  final String url;
  WebViewWidgetArguments(
      {this.note, this.key, this.questionPaper, this.syllabus, this.url});
}

//EditView arguments holder class
class EditViewArguments {
  final Key key;
  final String title;
  final Map<dynamic, dynamic> textFieldsMap;
  final Document path;
  final dynamic note;
  final String subjectName;
  EditViewArguments(
      {this.key,
      @required this.title,
      @required this.textFieldsMap,
      @required this.path,
      this.note,
      @required this.subjectName});
}
