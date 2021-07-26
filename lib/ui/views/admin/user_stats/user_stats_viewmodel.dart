import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.logger.dart';
import 'package:FSOUNotes/misc/course_info.dart';
import 'package:FSOUNotes/services/funtional_services/firebase_firestore/firestore_service.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';

Logger log = getLogger("UserStatsViewModel");

class UserStatsViewModel extends FutureViewModel {
  FirestoreService _firestoreService = locator<FirestoreService>();

  List<College> _colleges = [];
  List<Branch> _branches = [];
  List<Sem> _semesters = [];
  List<College> get colleges => _colleges;
  List<Branch> get branches => _branches;
  List<Sem> get semesters => _semesters;

  Map<String, dynamic> userStats;

  fetchUserStats() async {
    setBusy(true);
    //TODO
    //userStats = await _firestoreService.getUserStats();
    log.e(userStats);
    CourseInfo.colleges.forEach((college) async {
      _colleges.add(College(college, userStats[college]));
    });
    CourseInfo.branch.forEach((branch) async {
      _branches.add(Branch(branch, userStats[branch]));
    });
    CourseInfo.semesters.forEach((semester) async {
      _semesters.add(Sem(semester, userStats[semester]));
    });
    log.e(_colleges);
    log.e(_branches);
    log.e(_semesters);
    setBusy(false);
    notifyListeners();
  }

  Map<String, String> _clgs = {
    "Muffakham Jah College of Engineering and Technology": "MJCET",
    "Osmania University's College of Technology": "Osmania",
    "CBIT": "CBIT",
    "Vasavi": "VASAVI",
    "MVSR ": "MVSR",
    "Deccan College ": "DECCAN",
    "ISL Engineering College": "ISL",
    "Methodist ": "METHODIST",
    "Stanley College ": "STANLEY",
    "NGIT": "NGIT",
    "University College of Engineering": "UNIVERSITY",
    "Matrusri Engineering College": "MATRUSRI",
    "Swathi Institute of Technology & Science": "SWATHI",
    "JNTU Affiliated Colleges": "JNTU",
    "Other": "OTHER",
  };
  Map<String, String> get clgs => _clgs;

  @override
  Future futureToRun() => fetchUserStats();
}

class College {
  final String collegeName;
  final int noOfStudents;

  College(this.collegeName, this.noOfStudents);
}

class Sem {
  final String sem;
  final int noOfStudents;

  Sem(this.sem, this.noOfStudents);
}

class Branch {
  final String br;
  final int noOfStudents;

  Branch(this.br, this.noOfStudents);
}
