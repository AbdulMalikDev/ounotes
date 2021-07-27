

import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService{

  RemoteConfig _remoteConfig;

  RemoteConfig get remoteConfig => _remoteConfig;

  Future init() async {
    if (_remoteConfig == null)
    {
      _remoteConfig = await RemoteConfig.instance;
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ));
      RemoteConfigValue(null, ValueSource.valueStatic);
      _remoteConfig.fetchAndActivate();
      // //TODO DEV CHECKLIST
      //FIXME 
      // await remoteConfig.setConfigSettings(RemoteConfigSettings(minimumFetchInterval: const Duration(hours: 4)));
      // // await remoteConfig.fetch(expiration: const Duration(seconds: 1));
      // await remoteConfig.activate();
    }
  }
}