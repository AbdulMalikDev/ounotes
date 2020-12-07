import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/misc/course_info.dart';
import 'package:FSOUNotes/services/funtional_services/firestore_service.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
Logger log = getLogger("UserStatsViewModel");
class UserStatsViewModel extends FutureViewModel{

  FirestoreService _firestoreService = locator<FirestoreService>();

  Map<String,int> _colleges = {};
  Map<String,int> _branches = {};
  Map<String,int> _semesters = {};

  Map<String,dynamic> userStats;

  fetchUserStats() async {
    setBusy(true);
    userStats = await _firestoreService.getUserStats();
    log.e(userStats);
    CourseInfo.colleges.forEach((college) async { 
      _colleges.addAll({college:userStats[college]});       
    });
    CourseInfo.branch.forEach((branch) async { 
      _branches.addAll({branch:userStats[branch]});       
    });
    CourseInfo.semesters.forEach((semester) async { 
      _semesters.addAll({semester:userStats[semester]});       
    });
    log.e(_colleges);
    log.e(_branches);
    log.e(_semesters);
    setBusy(false);
    notifyListeners();
  }



  @override
  Future futureToRun() => fetchUserStats();

  //Getters and Setters
  Map<String,int> get colleges => _colleges;
  set colleges(Map<String,int> value) => _colleges = value;
  Map<String,int> get branches => _branches;
  set branches(Map<String,int> value) => _branches = value;
  Map<String,int> get semesters => _semesters;
  set semesters(Map<String,int> value) => _semesters = value;

}