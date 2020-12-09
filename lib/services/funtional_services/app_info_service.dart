

import 'package:FSOUNotes/app/logger.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:package_info/package_info.dart';

Logger log = getLogger("AdmobService");
@lazySingleton
class AppInfoService{
  PackageInfo _packageInfo;

  getPackageInfo() async {
    if(_packageInfo == null)_packageInfo = await PackageInfo.fromPlatform();
    return _packageInfo;
  }
  
}