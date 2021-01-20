

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class RemoteConfigService{

  RemoteConfig _remoteConfig;

  RemoteConfig get remoteConfig => _remoteConfig;

  Future init() async {
    if (_remoteConfig == null)
    {
      _remoteConfig = await RemoteConfig.instance;
      //TODO DEV CHECKLIST
      await remoteConfig.fetch(expiration: const Duration(hours: 4));
      // await remoteConfig.fetch(expiration: const Duration(seconds: 1));
      await remoteConfig.activateFetched();
    }
  }
}