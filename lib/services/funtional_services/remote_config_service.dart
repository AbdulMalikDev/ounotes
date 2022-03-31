

import 'package:FSOUNotes/app/app.logger.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:logger/logger.dart';
Logger log = getLogger("RemoteConfigService");
class RemoteConfigService{

  FirebaseRemoteConfig _remoteConfig;

  FirebaseRemoteConfig get remoteConfig => _remoteConfig;

  Future init() async {
    if (_remoteConfig == null)
    {
      log.e("loading remote config");
      _remoteConfig = FirebaseRemoteConfig.instance;
      // _remoteConfig = await RemoteConfig.instance;
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ));
      RemoteConfigValue(null, ValueSource.valueStatic);
      await _remoteConfig.fetchAndActivate();
      // //TODO DEV CHECKLIST
      //FIXME 
      // await remoteConfig.setConfigSettings(RemoteConfigSettings(minimumFetchInterval: const Duration(hours: 4)));
      // // await remoteConfig.fetch(expiration: const Duration(seconds: 1));
      // await remoteConfig.activate();
    }
  }
}