
import 'package:FSOUNotes/app/app.router.dart';
import 'package:FSOUNotes/models/user.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
import 'package:FSOUNotes/services/funtional_services/remote_config_service.dart';
import 'package:FSOUNotes/services/funtional_services/onboarding_service.dart';
import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.logger.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';
import 'package:stacked_services/stacked_services.dart';

Logger log = getLogger("AdmobService");
 
class AdmobService{

  RemoteConfigService _remoteConfigService = locator<RemoteConfigService>();
  AuthenticationService _authenticationService = locator<AuthenticationService>();
  NavigationService _navigationService = locator<NavigationService>();

  RemoteConfigService _remote = locator<RemoteConfigService>();
  String get ADMOB_APP_ID => _remote.remoteConfig.getString("ADMOB_APP_ID");
  // String get ADMOB_AD_BANNER_ID => _remote.remoteConfig.getString("ADMOB_AD_BANNER_ID");
  String get ADMOB_AD_INTERSTITIAL_ID => _remote.remoteConfig.getString("ADMOB_AD_INTERSTITIAL_ID");
  // String get ADMOB_AD_INTERSTITIAL_ID_TEST => "ca-app-pub-3940256099942544/1033173712";
  // String get ADMOB_REWARDED_AD_ID => _remoteConfigService.remoteConfig.getString("ADMOB_REWARDED_AD_ID");

  // BannerAd notes_view_banner_ad;
  InterstitialAd notes_view_interstitial_ad;

  int _NumberOfTimeNotesOpened = 1;
  int _NumberOfAdsShown = 0;
  // String appId;
  // String adUnitId;
  // MobileAdTargetingInfo info;
  // bool adDue = false;
  // bool adShown = false;
  
  int get NumberOfTimeNotesOpened => _NumberOfTimeNotesOpened;
  set NumberOfTimeNotesOpened(int value) => _NumberOfTimeNotesOpened = value;

  incrementNumberOfTimeNotesOpened() {
    log.e("incrementNumberOfTimeNotesOpened");
     if(_NumberOfTimeNotesOpened==null){
       _NumberOfTimeNotesOpened=0;
      }
      _NumberOfTimeNotesOpened++;
      OnboardingService.box.put("_NumberOfTimeNotesOpened", _NumberOfTimeNotesOpened);
      log.e(_NumberOfTimeNotesOpened.toString()+" notes opened incremented");
  }

  getNumberOfTimeNotesOpened(){
    log.e(OnboardingService.box.get("_NumberOfTimeNotesOpened"));
    int savedState = OnboardingService.box.get("_NumberOfTimeNotesOpened") ?? 0;
    _NumberOfTimeNotesOpened = savedState;
    log.e(savedState.toString() + " savedState");
    return savedState;
  }

  /// Returns true if add is shown
  /// and executes logic to show ad
  /// if user is eligible to be shown the ad
  Future<bool> showAd() async {

    try{

      log.e("Number of times notes screen opened : " + getNumberOfTimeNotesOpened().toString());
      if (getNumberOfTimeNotesOpened() % 4 == 0){
      // if (true){

        log.e("SHOW AD NOW");
        if(!(_authenticationService.user.isPremiumUser ?? false))
        {
          // _adFailedToBeShown();
          await _navigationService.navigateTo(Routes.watchAdToContinueView);
          return true;
        }

      }

      incrementNumberOfTimeNotesOpened();
      return false;

    } catch (e) {
      log.e("shouldAdBeShown - ERROR while calculating whather add should be shown ${e.toString()}");
      log.e(e.code);
      return false;
    }
  }

  showInterstitialAd() async {
    try {
      
      //>> Load Interstitial Ad
      await InterstitialAd.load(
      adUnitId: ADMOB_AD_INTERSTITIAL_ID,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          // Keep a reference to the ad so you can show it later.
          log.e("Ad loaded");
          notes_view_interstitial_ad = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          log.e('InterstitialAd failed to load: $error');
          // We don't want to show this if the users device is frequency capped
          print(error.message);
          print(error.code);
          print(error.responseInfo);
          print(error.domain);
          if(!error.message.contains("Frequency")){
            Fluttertoast.showToast(msg: "Ad failed to load");
          }
          // _navigationService.clearStackAndShow(Routes.splashView);
        },
      ));

      if(notes_view_interstitial_ad!=null){
        await notes_view_interstitial_ad.show();
      }
    } catch (e) {
      log.e(e);
    }

  }

  // init() async {
  //   this.adDue = OnboardingService.box.get("adDue") ?? false;
  //   appId = _remoteConfigService.remoteConfig.getString("ADMOB_APP_ID");
  //   adUnitId = _remoteConfigService.remoteConfig.getString("ADMOB_REWARDED_AD_ID");
  //   FirebaseAdMob.instance.initialize(appId: appId);
  //   info = MobileAdTargetingInfo(keywords: ["Education","coding","books",],testDevices: ["5e99a12e-fa96-42f0-a42d-ece240d3bca9"]);
  //   RewardedVideoAd.instance.listener =
  //   (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
  //     log.e("event" + event.toString());
  //     if (event == RewardedVideoAdEvent.rewarded) {
  //       log.e(rewardAmount);
  //       log.e(rewardType);
  //       _adSuccessfullyShown();
  //     }
  //     if (event == RewardedVideoAdEvent.loaded) {
  //       log.e(rewardAmount);
  //       log.e(rewardType);
  //       if(!adShown && adDue)
  //       RewardedVideoAd.instance.show()
  //       .catchError((e) => log.e("error in loading again"))
  //       .then((v) => log.e("Ad Loaded"));
  //     }
  //     if (event == RewardedVideoAdEvent.closed) {
  //     RewardedVideoAd.instance
  //         .load(adUnitId: RewardedVideoAd.testAdUnitId, targetingInfo: info)
  //         .catchError((e) => log.e("error in loading again"))
  //         .then((v) => log.e("Ad Loaded"));
  //     }
  //     if (event == RewardedVideoAdEvent.failedToLoad){
  //       log.e("failedToLoad");
  //       // _adFailedToBeShown();
  //     }
  //   };
  //   // await RewardedVideoAd.instance.load(adUnitId : adUnitId , targetingInfo: info);
  //   this.user = await _authenticationService.getUser();
  // }

  // watchAdNow() async {
  //   try {

  //     log.e(adUnitId);
  //     log.e(appId);
  //     bool adloaded = await RewardedVideoAd.instance.load(adUnitId : ADMOB_REWARDED_AD_ID , targetingInfo: info);
  //     log.e(adloaded);
      
  //   } catch (e) {
  //     log.e(e.toString());
  //     log.e(e.code);
  //   }
  // }

  // showInterstitialAd() async {
  //   log.e("Showing Interstitial");
  //   await getInterstitialAd()..load()..show();
  //   _adSuccessfullyShown();
  // }

  // InterstitialAd getInterstitialAd() {
  //   return InterstitialAd(
  //       // adUnitId: InterstitialAd.testAdUnitId,
  //       adUnitId: ADMOB_AD_INTERSTITIAL_ID,
  //       targetingInfo: info,
  //       listener: (MobileAdEvent event) {
  //       print("InterstitialAd event is $event");
  //     },
  //   );
  // }

  // _adSuccessfullyShown() {
  //   adShown = true;
  //   OnboardingService.box.put("adShown", adShown);
  //   adDue = false;
  //   OnboardingService.box.put("adDue", adDue);
  //   incrementNumberOfTimeNotesOpened();
  // }

  // _adFailedToBeShown() {
  //   adShown = false;
  //   OnboardingService.box.put("adShown", adShown);
  //   adDue = true;
  //   OnboardingService.box.put("adDue", adDue);
  // }

  
}