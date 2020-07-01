import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/models/report.dart';
import 'package:FSOUNotes/services/funtional_services/sharedpref_service.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@lazySingleton
class ReportsService{
      Logger log = getLogger("ReportsService");
      List<Report> _reports = [];

      List<Report> get reports => _reports;

      set setReport(List<Report> reports){_reports = reports;}

      bool get isReportPresent => _reports!=null;


      loadReports() async{
        SharedPreferencesService prefs = locator<SharedPreferencesService>();
        _reports = await prefs.loadReportsFromStorage();
      }

      addReport(Report report) async
      {
        SharedPreferencesService prefs = locator<SharedPreferencesService>();
        if(_reports!=null && _isReportExist(report))
        {
          return "You have already reported this. Kindly wait for the admins to check it or use the feedback feature to contact us";
        
        }else{

        _reports.add(report);
        print(_reports!=null);
        print(_reports.contains(report));
        print(reports);
        await prefs.storeReport(_reports);
        return true;
        }
      }

      _isReportExist(Report report)
      {
        var isExist = _reports.firstWhere((element) => element.title == report.title , orElse: () => null);
        return isExist != null;
      }
}