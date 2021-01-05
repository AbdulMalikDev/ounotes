
import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/services/funtional_services/remote_config_service.dart';
import 'package:FSOUNotes/services/funtional_services/onboarding_service.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:logger/logger.dart';
import 'package:FSOUNotes/app/logger.dart';

Logger log = getLogger("AdmobService");
@lazySingleton 
class AdmobService{

  RemoteConfigService _remote = locator<RemoteConfigService>();
  String get ADMOB_APP_ID => _remote.remoteConfig.getString("ADMOB_APP_ID");
  String get ADMOB_AD_BANNER_ID => _remote.remoteConfig.getString("ADMOB_AD_BANNER_ID");
  String get ADMOB_AD_INTERSTITIAL_ID => _remote.remoteConfig.getString("ADMOB_AD_INTERSTITIAL_ID");

  BannerAd notes_view_banner_ad;
  InterstitialAd notes_view_interstitial_ad;

  int _NumberOfTimeNotesOpened = 1;
  int _NumberOfAdsShown = 0;

  int get NumberOfTimeNotesOpened => _NumberOfTimeNotesOpened;
  set NumberOfTimeNotesOpened(int value) => _NumberOfTimeNotesOpened = value;

  incrementNumberOfTimeNotesOpened() {
     if(_NumberOfTimeNotesOpened==null){
       _NumberOfTimeNotesOpened=0;
      }
      _NumberOfTimeNotesOpened++;
      OnboardingService.box.put("_NumberOfTimeNotesOpened", _NumberOfTimeNotesOpened);
      print(_NumberOfTimeNotesOpened);
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
      
      bool ad =getNumberOfTimeNotesOpened() % 7 == 0;
      
      if (ad){
        
        if(_NumberOfTimeNotesOpened==null){_NumberOfTimeNotesOpened=0;}
        incrementNumberOfTimeNotesOpened();
        _NumberOfAdsShown++;
      }
      return ad ?? false;

    } on Exception catch (e) {
      log.e("shouldAdBeShown - ERROR while calculating whather add should be shown ${e.toString()}");
      return false;
    }
  }

  
  BannerAd getNotesViewBannerAd(){
    return BannerAd(adUnitId:ADMOB_AD_BANNER_ID,size: AdSize.fullBanner);
  }

  InterstitialAd getNotesViewInterstitialAd(){
    return InterstitialAd(adUnitId:ADMOB_AD_INTERSTITIAL_ID);
  }

  showNotesViewBanner(){
    if(notes_view_banner_ad == null ){notes_view_banner_ad = this.getNotesViewBannerAd();}
    notes_view_banner_ad
      ..load()
      ..show(anchorType: AnchorType.bottom);
  }

  // listener(AdColonyAdListener event) {
  //   print(event);
  //   if (event == AdColonyAdListener.onRequestFilled) AdColony.show();
  // }
  showNotesViewInterstitialAd(){
    // final zones = [_remote.remoteConfig.getString('ADCOLONY_ZONE_INTERSTITIAL')];
    // AdColony.request(zones[0], listener);
    if(notes_view_interstitial_ad == null ){notes_view_interstitial_ad = this.getNotesViewInterstitialAd();}
    notes_view_interstitial_ad
      ..load()
      ..show();

  }

  hideNotesViewBanner() async {
    try {
      notes_view_banner_ad?.dispose();
      notes_view_banner_ad = null;
    } catch (ex) {
      log.e("banner dispose error");
    }
  }
  hideNotesViewInterstitialAd() async {
    try {
      notes_view_interstitial_ad?.dispose();
      notes_view_interstitial_ad = null;
    } catch (ex) {
      log.e("Intersitial ad dispose error");
    }
  }
  
}