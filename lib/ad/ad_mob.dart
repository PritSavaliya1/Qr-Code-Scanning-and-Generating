import 'dart:io';
import 'package:QRScanGenerate/Widget/banner_ad.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobServices {
  static String? get bannerAdUnitID {
    if (Platform.isAndroid) {
      return 'ca-app-pub-8756926608937514/9665390348';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-8756926608937514/9665390348';
    }
    return 'ca-app-pub-8756926608937514/9665390348';
  }

  static String? get secondBannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-8756926608937514/3905581602';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-8756926608937514/3905581602';
    }
    return 'ca-app-pub-8756926608937514/3905581602';
  }
  
static String? get rewardAd {
    if (Platform.isAndroid) {
      return 'ca-app-pub-8756926608937514/6447058424';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-8756926608937514/6447058424';
    }
    return 'ca-app-pub-8756926608937514/6447058424';
  }
  static String get interstitialAdUniId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-8756926608937514/7318530239';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-8756926608937514/7318530239';
    }
    return '';
  }

  static final BannerAdListener bannerAdListener = BannerAdListener(
    onAdLoaded: (ad) => debugPrint('ad loaded'),
    onAdFailedToLoad: (ad, error) {
      ad.dispose();
      debugPrint('ad failed to load');
      print("--------------------");
      print(error);
    },
    onAdOpened: (ad) => debugPrint('Ad Opended'),
    onAdClosed: (ad) => debugPrint('Ad Closed'),
  );
}
