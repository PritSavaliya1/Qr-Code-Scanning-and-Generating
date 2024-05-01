import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:QRScanGenerate/ad/ad_mob.dart';

class BannerAdWidget extends StatefulWidget {
  @override
  _BannerAdWidgetState createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  late BannerAd _bannerAd;

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdMobServices.bannerAdUnitID!,
      listener: AdMobServices.bannerAdListener!,
      request: const AdRequest(),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return _bannerAd == null
        ? SizedBox()
        : Container(
            margin: const EdgeInsets.only(bottom: 12),
            height: 52,
            child: AdWidget(ad: _bannerAd),
          );
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }
}


class SecondBannerAdWidget extends StatefulWidget {
  @override
  _SecondBannerAdWidgetState createState() => _SecondBannerAdWidgetState();
}

class _SecondBannerAdWidgetState extends State<SecondBannerAdWidget> {
  late BannerAd _bannerAd;

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdMobServices.secondBannerAdUnitId!,
      listener: AdMobServices.bannerAdListener!,
      request: const AdRequest(),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return _bannerAd == null
        ? SizedBox()
        : Container(
            margin: const EdgeInsets.only(bottom: 12),
            height: 52,
            child: AdWidget(ad: _bannerAd),
          );
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }
}
