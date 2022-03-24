// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../enums/enums.dart';
import '../models/UploadLog.dart';
import '../models/document.dart';
import '../models/notes.dart';
import '../models/question_paper.dart';
import '../models/syllabus.dart';
import '../models/verifier.dart';
import '../ui/views/FilterDocuments/FD_DocumentDisplay/fd_documentview.dart';
import '../ui/views/FilterDocuments/FD_InputScreen/fd_inputView.dart';
import '../ui/views/FilterDocuments/FD_subjectdisplay/fd_subjectview.dart';
import '../ui/views/Main/main_screen_view.dart';
import '../ui/views/Settings/account_info/account_info_view.dart';
import '../ui/views/Settings/settings_view.dart';
import '../ui/views/about_us/about_us_view.dart';
import '../ui/views/about_us/privacy_policy/privacy_policyview.dart';
import '../ui/views/about_us/privacy_policy/terms_and_conditionview.dart';
import '../ui/views/admin/add_verifier/add_verifier_view.dart';
import '../ui/views/admin/admin_view.dart';
import '../ui/views/admin/upload_log/upload_log_detail/upload_log_detail_view.dart';
import '../ui/views/admin/upload_log/upload_log_detail/upload_log_edit/upload_log_edit_view.dart';
import '../ui/views/admin/upload_log/upload_log_view.dart';
import '../ui/views/all_documents/all_documents_view.dart';
import '../ui/views/downloads/Downloads_view.dart';
import '../ui/views/edit/edit_view.dart';
import '../ui/views/home/home_view.dart';
import '../ui/views/home/recently_added_notes/recently_added_notes_view.dart';
import '../ui/views/intro/intro_view.dart';
import '../ui/views/links/links_view.dart';
import '../ui/views/notes/notes_view.dart';
import '../ui/views/notification/notification_view.dart';
import '../ui/views/pdf/pdf_view.dart';
import '../ui/views/question_papers/question_papers_view.dart';
import '../ui/views/splash/spash_view.dart';
import '../ui/views/syllabus/syllabus_view.dart';
import '../ui/views/upload/upload_selection/upload_selection_view.dart';
import '../ui/views/upload/upload_view.dart';
import '../ui/views/verifier/reported%20documents/reported_documents_view.dart';
import '../ui/views/verifier/verifier_view.dart';
import '../ui/views/verifier/verify%20documents/verify_documents_view.dart';
import '../ui/views/web_view/web_view.dart';
import '../ui/widgets/smart_widgets/thank_you_page/thank_you_view.dart';
import '../ui/widgets/smart_widgets/thank_you_page/upload_thank_you/thank_you_for_uploading.dart';
import '../ui/widgets/smart_widgets/watch_ad/watch_ad_view.dart';
import '../ui/widgets/smart_widgets/why_to_pay_for_download_page/why_to_pay_for_download.dart';

class Routes {
  static const String splashView = '/';
  static const String introView = '/intro-view';
  static const String homeView = '/home-view';
  static const String allDocumentsView = '/all-documents-view';
  static const String pDFScreen = '/p-df-screen';
  static const String notesView = '/notes-view';
  static const String questionPapersView = '/question-papers-view';
  static const String syllabusView = '/syllabus-view';
  static const String linksView = '/links-view';
  static const String aboutUsView = '/about-us-view';
  static const String settingsView = '/settings-view';
  static const String uploadView = '/upload-view';
  static const String uploadSelectionView = '/upload-selection-view';
  static const String downLoadView = '/down-load-view';
  static const String fDInputView = '/f-dinput-view';
  static const String fDSubjectView = '/f-dsubject-view';
  static const String fDDocumentView = '/f-ddocument-view';
  static const String privacyPolicyView = '/privacy-policy-view';
  static const String termsAndConditionView = '/terms-and-condition-view';
  static const String adminView = '/admin-view';
  static const String webViewWidget = '/web-view-widget';
  static const String editView = '/edit-view';
  static const String uploadLogView = '/upload-log-view';
  static const String uploadLogDetailView = '/upload-log-detail-view';
  static const String uploadLogEditView = '/upload-log-edit-view';
  static const String watchAdToContinueView = '/watch-ad-to-continue-view';
  static const String thankYouView = '/thank-you-view';
  static const String thankYouForUploadingView =
      '/thank-you-for-uploading-view';
  static const String whyToPayForDownloadView = '/why-to-pay-for-download-view';
  static const String addVerifierView = '/add-verifier-view';
  static const String verifierPanelView = '/verifier-panel-view';
  static const String verifyDocumentsView = '/verify-documents-view';
  static const String reportedDocumentsView = '/reported-documents-view';
  static const String notificationView = '/notification-view';
  static const String recentlyAddedNotesView = '/recently-added-notes-view';
  static const String accountInfoView = '/account-info-view';
  static const String mainView = '/main-view';
  static const all = <String>{
    splashView,
    introView,
    homeView,
    allDocumentsView,
    pDFScreen,
    notesView,
    questionPapersView,
    syllabusView,
    linksView,
    aboutUsView,
    settingsView,
    uploadView,
    uploadSelectionView,
    downLoadView,
    fDInputView,
    fDSubjectView,
    fDDocumentView,
    privacyPolicyView,
    termsAndConditionView,
    adminView,
    webViewWidget,
    editView,
    uploadLogView,
    uploadLogDetailView,
    uploadLogEditView,
    watchAdToContinueView,
    thankYouView,
    thankYouForUploadingView,
    whyToPayForDownloadView,
    addVerifierView,
    verifierPanelView,
    verifyDocumentsView,
    reportedDocumentsView,
    notificationView,
    recentlyAddedNotesView,
    accountInfoView,
    mainView,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.splashView, page: SplashView),
    RouteDef(Routes.introView, page: IntroView),
    RouteDef(Routes.homeView, page: HomeView),
    RouteDef(Routes.allDocumentsView, page: AllDocumentsView),
    RouteDef(Routes.pDFScreen, page: PDFScreen),
    RouteDef(Routes.notesView, page: NotesView),
    RouteDef(Routes.questionPapersView, page: QuestionPapersView),
    RouteDef(Routes.syllabusView, page: SyllabusView),
    RouteDef(Routes.linksView, page: LinksView),
    RouteDef(Routes.aboutUsView, page: AboutUsView),
    RouteDef(Routes.settingsView, page: SettingsView),
    RouteDef(Routes.uploadView, page: UploadView),
    RouteDef(Routes.uploadSelectionView, page: UploadSelectionView),
    RouteDef(Routes.downLoadView, page: DownLoadView),
    RouteDef(Routes.fDInputView, page: FDInputView),
    RouteDef(Routes.fDSubjectView, page: FDSubjectView),
    RouteDef(Routes.fDDocumentView, page: FDDocumentView),
    RouteDef(Routes.privacyPolicyView, page: PrivacyPolicyView),
    RouteDef(Routes.termsAndConditionView, page: TermsAndConditionView),
    RouteDef(Routes.adminView, page: AdminView),
    RouteDef(Routes.webViewWidget, page: WebViewWidget),
    RouteDef(Routes.editView, page: EditView),
    RouteDef(Routes.uploadLogView, page: UploadLogView),
    RouteDef(Routes.uploadLogDetailView, page: UploadLogDetailView),
    RouteDef(Routes.uploadLogEditView, page: UploadLogEditView),
    RouteDef(Routes.watchAdToContinueView, page: WatchAdToContinueView),
    RouteDef(Routes.thankYouView, page: ThankYouView),
    RouteDef(Routes.thankYouForUploadingView, page: ThankYouForUploadingView),
    RouteDef(Routes.whyToPayForDownloadView, page: WhyToPayForDownloadView),
    RouteDef(Routes.addVerifierView, page: AddVerifierView),
    RouteDef(Routes.verifierPanelView, page: VerifierPanelView),
    RouteDef(Routes.verifyDocumentsView, page: VerifyDocumentsView),
    RouteDef(Routes.reportedDocumentsView, page: ReportedDocumentsView),
    RouteDef(Routes.notificationView, page: NotificationView),
    RouteDef(Routes.recentlyAddedNotesView, page: RecentlyAddedNotesView),
    RouteDef(Routes.accountInfoView, page: AccountInfoView),
    RouteDef(Routes.mainView, page: MainView),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    SplashView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => SplashView(),
        settings: data,
      );
    },
    IntroView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const IntroView(),
        settings: data,
      );
    },
    HomeView: (data) {
      var args = data.getArgs<HomeViewArguments>(
        orElse: () => HomeViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => HomeView(
          key: args.key,
          shouldShowUpdateDialog: args.shouldShowUpdateDialog,
          versionDetails: args.versionDetails,
        ),
        settings: data,
      );
    },
    AllDocumentsView: (data) {
      var args = data.getArgs<AllDocumentsViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => AllDocumentsView(
          subjectName: args.subjectName,
          path: args.path,
          newDocIDUploaded: args.newDocIDUploaded,
        ),
        settings: data,
      );
    },
    PDFScreen: (data) {
      var args = data.getArgs<PDFScreenArguments>(
        orElse: () => PDFScreenArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => PDFScreen(
          pathPDF: args.pathPDF,
          doc: args.doc,
          isUploadingDoc: args.isUploadingDoc,
        ),
        settings: data,
      );
    },
    NotesView: (data) {
      var args = data.getArgs<NotesViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => NotesView(
          subjectName: args.subjectName,
          path: args.path,
          newDocIDUploaded: args.newDocIDUploaded,
          key: args.key,
        ),
        settings: data,
      );
    },
    QuestionPapersView: (data) {
      var args = data.getArgs<QuestionPapersViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => QuestionPapersView(
          subjectName: args.subjectName,
          path: args.path,
          key: args.key,
        ),
        settings: data,
      );
    },
    SyllabusView: (data) {
      var args = data.getArgs<SyllabusViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => SyllabusView(
          subjectName: args.subjectName,
          path: args.path,
          key: args.key,
        ),
        settings: data,
      );
    },
    LinksView: (data) {
      var args = data.getArgs<LinksViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => LinksView(
          subjectName: args.subjectName,
          path: args.path,
          key: args.key,
        ),
        settings: data,
      );
    },
    AboutUsView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const AboutUsView(),
        settings: data,
      );
    },
    SettingsView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const SettingsView(),
        settings: data,
      );
    },
    UploadView: (data) {
      var args = data.getArgs<UploadViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => UploadView(
          textFieldsMap: args.textFieldsMap,
          subjectName: args.subjectName,
        ),
        settings: data,
      );
    },
    UploadSelectionView: (data) {
      var args = data.getArgs<UploadSelectionViewArguments>(
        orElse: () => UploadSelectionViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => UploadSelectionView(
          subjectName: args.subjectName,
        ),
        settings: data,
      );
    },
    DownLoadView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const DownLoadView(),
        settings: data,
      );
    },
    FDInputView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const FDInputView(),
        settings: data,
      );
    },
    FDSubjectView: (data) {
      var args = data.getArgs<FDSubjectViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => FDSubjectView(
          sem: args.sem,
          br: args.br,
          path: args.path,
          key: args.key,
        ),
        settings: data,
      );
    },
    FDDocumentView: (data) {
      var args = data.getArgs<FDDocumentViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => FDDocumentView(
          subjectName: args.subjectName,
          path: args.path,
          key: args.key,
        ),
        settings: data,
      );
    },
    PrivacyPolicyView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const PrivacyPolicyView(),
        settings: data,
      );
    },
    TermsAndConditionView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const TermsAndConditionView(),
        settings: data,
      );
    },
    AdminView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => AdminView(),
        settings: data,
      );
    },
    WebViewWidget: (data) {
      var args = data.getArgs<WebViewWidgetArguments>(
        orElse: () => WebViewWidgetArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => WebViewWidget(
          note: args.note,
          key: args.key,
          questionPaper: args.questionPaper,
          syllabus: args.syllabus,
          url: args.url,
        ),
        settings: data,
      );
    },
    EditView: (data) {
      var args = data.getArgs<EditViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => EditView(
          key: args.key,
          title: args.title,
          textFieldsMap: args.textFieldsMap,
          path: args.path,
          note: args.note,
          subjectName: args.subjectName,
        ),
        settings: data,
      );
    },
    UploadLogView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const UploadLogView(),
        settings: data,
      );
    },
    UploadLogDetailView: (data) {
      var args = data.getArgs<UploadLogDetailViewArguments>(
        orElse: () => UploadLogDetailViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => UploadLogDetailView(logItem: args.logItem),
        settings: data,
      );
    },
    UploadLogEditView: (data) {
      var args = data.getArgs<UploadLogEditViewArguments>(
        orElse: () => UploadLogEditViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => UploadLogEditView(
          uploadLog: args.uploadLog,
          key: args.key,
        ),
        settings: data,
      );
    },
    WatchAdToContinueView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => WatchAdToContinueView(),
        settings: data,
      );
    },
    ThankYouView: (data) {
      var args = data.getArgs<ThankYouViewArguments>(
        orElse: () => ThankYouViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => ThankYouView(filePath: args.filePath),
        settings: data,
      );
    },
    ThankYouForUploadingView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => ThankYouForUploadingView(),
        settings: data,
      );
    },
    WhyToPayForDownloadView: (data) {
      var args = data.getArgs<WhyToPayForDownloadViewArguments>(
        orElse: () => WhyToPayForDownloadViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => WhyToPayForDownloadView(price: args.price),
        settings: data,
      );
    },
    AddVerifierView: (data) {
      var args = data.getArgs<AddVerifierViewArguments>(
        orElse: () => AddVerifierViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => AddVerifierView(verifier: args.verifier),
        settings: data,
      );
    },
    VerifierPanelView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const VerifierPanelView(),
        settings: data,
      );
    },
    VerifyDocumentsView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => VerifyDocumentsView(),
        settings: data,
      );
    },
    ReportedDocumentsView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => ReportedDocumentsView(),
        settings: data,
      );
    },
    NotificationView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const NotificationView(),
        settings: data,
      );
    },
    RecentlyAddedNotesView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const RecentlyAddedNotesView(),
        settings: data,
      );
    },
    AccountInfoView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const AccountInfoView(),
        settings: data,
      );
    },
    MainView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const MainView(),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// HomeView arguments holder class
class HomeViewArguments {
  final Key key;
  final bool shouldShowUpdateDialog;
  final Map<String, dynamic> versionDetails;
  HomeViewArguments(
      {this.key, this.shouldShowUpdateDialog, this.versionDetails});
}

/// AllDocumentsView arguments holder class
class AllDocumentsViewArguments {
  final String subjectName;
  final String path;
  final String newDocIDUploaded;
  AllDocumentsViewArguments(
      {@required this.subjectName, this.path, this.newDocIDUploaded});
}

/// PDFScreen arguments holder class
class PDFScreenArguments {
  final String pathPDF;
  final AbstractDocument doc;
  final bool isUploadingDoc;
  PDFScreenArguments({this.pathPDF, this.doc, this.isUploadingDoc});
}

/// NotesView arguments holder class
class NotesViewArguments {
  final String subjectName;
  final String path;
  final String newDocIDUploaded;
  final Key key;
  NotesViewArguments(
      {@required this.subjectName, this.path, this.newDocIDUploaded, this.key});
}

/// QuestionPapersView arguments holder class
class QuestionPapersViewArguments {
  final String subjectName;
  final String path;
  final Key key;
  QuestionPapersViewArguments(
      {@required this.subjectName, this.path, this.key});
}

/// SyllabusView arguments holder class
class SyllabusViewArguments {
  final String subjectName;
  final String path;
  final Key key;
  SyllabusViewArguments({@required this.subjectName, this.path, this.key});
}

/// LinksView arguments holder class
class LinksViewArguments {
  final String subjectName;
  final String path;
  final Key key;
  LinksViewArguments({@required this.subjectName, this.path, this.key});
}

/// UploadView arguments holder class
class UploadViewArguments {
  final Map<dynamic, dynamic> textFieldsMap;
  final String subjectName;
  final Document path;
  final Document path2;
  UploadViewArguments(
      {this.textFieldsMap, @required this.subjectName, this.path, this.path2});
}

/// UploadSelectionView arguments holder class
class UploadSelectionViewArguments {
  final String subjectName;
  final Document path;
  UploadSelectionViewArguments({this.subjectName, this.path});
}

/// FDSubjectView arguments holder class
class FDSubjectViewArguments {
  final String sem;
  final String br;
  final Document path;
  final Key key;
  FDSubjectViewArguments(
      {@required this.sem, @required this.br, @required this.path, this.key});
}

/// FDDocumentView arguments holder class
class FDDocumentViewArguments {
  final String subjectName;
  final Document path;
  final Key key;
  FDDocumentViewArguments({@required this.subjectName, this.path, this.key});
}

/// WebViewWidget arguments holder class
class WebViewWidgetArguments {
  final Note note;
  final Key key;
  final QuestionPaper questionPaper;
  final Syllabus syllabus;
  final String url;
  WebViewWidgetArguments(
      {this.note, this.key, this.questionPaper, this.syllabus, this.url});
}

/// EditView arguments holder class
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

/// UploadLogDetailView arguments holder class
class UploadLogDetailViewArguments {
  final UploadLog logItem;
  UploadLogDetailViewArguments({this.logItem});
}

/// UploadLogEditView arguments holder class
class UploadLogEditViewArguments {
  final UploadLog uploadLog;
  final Key key;
  UploadLogEditViewArguments({this.uploadLog, this.key});
}

/// ThankYouView arguments holder class
class ThankYouViewArguments {
  final String filePath;
  ThankYouViewArguments({this.filePath});
}

/// WhyToPayForDownloadView arguments holder class
class WhyToPayForDownloadViewArguments {
  final String price;
  WhyToPayForDownloadViewArguments({this.price});
}

/// AddVerifierView arguments holder class
class AddVerifierViewArguments {
  final Verifier verifier;
  AddVerifierViewArguments({this.verifier});
}
