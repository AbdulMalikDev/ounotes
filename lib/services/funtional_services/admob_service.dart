
import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/models/user.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
import 'package:FSOUNotes/services/funtional_services/remote_config_service.dart';
import 'package:FSOUNotes/services/funtional_services/onboarding_service.dart';
import 'package:injectable/injectable.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:logger/logger.dart';
import 'package:FSOUNotes/app/logger.dart';

Logger log = getLogger("AdmobService");
@lazySingleton 
class AdmobService{

  RemoteConfigService _remoteConfigService = locator<RemoteConfigService>();
  AuthenticationService _authenticationService = locator<AuthenticationService>();

  RemoteConfigService _remote = locator<RemoteConfigService>();
  String get ADMOB_APP_ID => _remote.remoteConfig.getString("ADMOB_APP_ID");
  String get ADMOB_AD_BANNER_ID => _remote.remoteConfig.getString("ADMOB_AD_BANNER_ID");
  String get ADMOB_AD_INTERSTITIAL_ID => _remote.remoteConfig.getString("ADMOB_AD_INTERSTITIAL_ID");
  String get ADMOB_REWARDED_AD_ID => _remoteConfigService.remoteConfig.getString("ADMOB_REWARDED_AD_ID");

  BannerAd notes_view_banner_ad;
  InterstitialAd notes_view_interstitial_ad;

  int _NumberOfTimeNotesOpened = 1;
  int _NumberOfAdsShown = 0;
  String appId;
  String adUnitId;
  MobileAdTargetingInfo info;
  bool adDue = false;
  bool adShown = false;
  User user;
  
  int get NumberOfTimeNotesOpened => _NumberOfTimeNotesOpened;
  set NumberOfTimeNotesOpened(int value) => _NumberOfTimeNotesOpened = value;

  incrementNumberOfTimeNotesOpened() {
     if(_NumberOfTimeNotesOpened==null){
       _NumberOfTimeNotesOpened=0;
      }
      _NumberOfTimeNotesOpened++;
      OnboardingService.box.put("_NumberOfTimeNotesOpened", _NumberOfTimeNotesOpened);
      print(_NumberOfTimeNotesOpened.toString()+"this many time notes opened");
  }

  getNumberOfTimeNotesOpened(){
    int savedState = OnboardingService.box.get("_NumberOfTimeNotesOpened") ?? 1;
    _NumberOfTimeNotesOpened = savedState;
    print(savedState.toString() + "savedState");
    return savedState;
  }

  bool shouldAdBeShown() {

    try {
      if(_NumberOfTimeNotesOpened==null){_NumberOfTimeNotesOpened=0;}
      if(_NumberOfAdsShown==null){_NumberOfAdsShown=0;}

      log.e(getNumberOfTimeNotesOpened());
      bool ad = getNumberOfTimeNotesOpened() % 9 == 0;
      
      if (ad){
        
        if(_NumberOfTimeNotesOpened==null){_NumberOfTimeNotesOpened=0;}
        log.e("SHOW AD NOW");
        if(!user.isPremiumUser)
        {
          _adFailedToBeShown();
          // watchAdNow();
          _NumberOfAdsShown++;
        }

      }
      return ad ?? false;

    } catch (e) {
      log.e("shouldAdBeShown - ERROR while calculating whather add should be shown ${e.toString()}");
      log.e(e.code);
      return false;
    }
  }

  init() async {
    this.adDue = OnboardingService.box.get("adDue") ?? false;
    appId = _remoteConfigService.remoteConfig.getString("ADMOB_APP_ID");
    adUnitId = _remoteConfigService.remoteConfig.getString("ADMOB_REWARDED_AD_ID");
    FirebaseAdMob.instance.initialize(appId: appId);
    info = MobileAdTargetingInfo(keywords: ["Education","coding","books",],testDevices: ["5e99a12e-fa96-42f0-a42d-ece240d3bca9"]);
    RewardedVideoAd.instance.listener =
    (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      log.e("event" + event.toString());
      if (event == RewardedVideoAdEvent.rewarded) {
        log.e(rewardAmount);
        log.e(rewardType);
        _adSuccessfullyShown();
      }
      if (event == RewardedVideoAdEvent.loaded) {
        log.e(rewardAmount);
        log.e(rewardType);
        if(!adShown && adDue)
        RewardedVideoAd.instance.show()
        .catchError((e) => log.e("error in loading again"))
        .then((v) => log.e("Ad Loaded"));
      }
      if (event == RewardedVideoAdEvent.closed) {
      RewardedVideoAd.instance
          .load(adUnitId: RewardedVideoAd.testAdUnitId, targetingInfo: info)
          .catchError((e) => log.e("error in loading again"))
          .then((v) => log.e("Ad Loaded"));
      }
      if (event == RewardedVideoAdEvent.failedToLoad){
        log.e("failedToLoad");
        // _adFailedToBeShown();
      }
    };
    // await RewardedVideoAd.instance.load(adUnitId : adUnitId , targetingInfo: info);
    this.user = await _authenticationService.getUser();
  }

  watchAdNow() async {
    try {

      log.e(adUnitId);
      log.e(appId);
      bool adloaded = await RewardedVideoAd.instance.load(adUnitId : ADMOB_REWARDED_AD_ID , targetingInfo: info);
      log.e(adloaded);
      
    } catch (e) {
      log.e(e.toString());
      log.e(e.code);
    }
  }

  showInterstitialAd() async {
    log.e("Showing Interstitial");
    await getInterstitialAd()..load()..show();
    _adSuccessfullyShown();
  }

  InterstitialAd getInterstitialAd() {
    return InterstitialAd(
        // adUnitId: InterstitialAd.testAdUnitId,
        adUnitId: ADMOB_AD_INTERSTITIAL_ID,
        targetingInfo: info,
        listener: (MobileAdEvent event) {
        print("InterstitialAd event is $event");
      },
    );
  }

  _adSuccessfullyShown() {
    adShown = true;
    OnboardingService.box.put("adShown", adShown);
    adDue = false;
    OnboardingService.box.put("adDue", adDue);
    incrementNumberOfTimeNotesOpened();
  }

  _adFailedToBeShown() {
    adShown = false;
    OnboardingService.box.put("adShown", adShown);
    adDue = true;
    OnboardingService.box.put("adDue", adDue);
  }

  
}