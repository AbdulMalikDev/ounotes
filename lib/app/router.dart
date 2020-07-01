import 'package:FSOUNotes/ui/views/FilterDocuments/FD_DocumentDisplay/fd_documentview.dart';
import 'package:FSOUNotes/ui/views/FilterDocuments/FD_InputScreen/fd_inputView.dart';
import 'package:FSOUNotes/ui/views/FilterDocuments/FD_subjectdisplay/fd_subjectview.dart';
import 'package:FSOUNotes/ui/views/Profile/profile_view.dart';
import 'package:FSOUNotes/ui/views/about_us/privacy_policy/privacy_policyview.dart';
import 'package:FSOUNotes/ui/views/about_us/privacy_policy/terms_and_conditionview.dart';
import 'package:FSOUNotes/ui/views/all_documents/all_documents_view.dart';
import 'package:FSOUNotes/ui/views/all_documents/upload/upload_selection/upload_selection_view.dart';
import 'package:FSOUNotes/ui/views/all_documents/upload/upload_view.dart';
import 'package:FSOUNotes/ui/views/downloads/Downloads_view.dart';
import 'package:FSOUNotes/ui/views/home/home_view.dart';
import 'package:FSOUNotes/ui/views/intro/intro_view.dart';
import 'package:FSOUNotes/ui/views/links/links_view.dart';
import 'package:FSOUNotes/ui/views/notes/notes_view.dart';
import 'package:FSOUNotes/ui/views/pdf/pdf_view.dart';
import 'package:FSOUNotes/ui/views/question_papers/question_papers_view.dart';
import 'package:FSOUNotes/ui/views/splash/spash_view.dart';
import 'package:FSOUNotes/ui/views/syllabus/syllabus_view.dart';
import 'package:auto_route/auto_route_annotations.dart';
import 'package:FSOUNotes/ui/views/about_us/about_us_view.dart';

@MaterialAutoRouter()
class $Router {
  @initial
  SplashView splashViewRoute;
  IntroView introViewRoute;
  HomeView homeViewRoute;
  AllDocumentsView allDocumentsViewRoute;
  PDFScreen pdfScreenRoute;
  NotesView notesViewRoute;
  QuestionPapersView questionPapersViewRoute;
  SyllabusView syllabusViewRoute;
  LinksView linksViewRoute;
  AboutUsView aboutUsViewRoute;
  ProfileView profileView;
  UploadView uploadViewRoute;
  UploadSelectionView uploadSelectionViewRoute;
  DownLoadView downLoadView;
  FDInputView fdInputView;
  FDSubjectView fdSubjectView;
  FDDocumentView fdDocumentView;
  PrivacyPolicyView privacyPolicyView;
  TermsAndConditionView termsAndConditionView;
}
