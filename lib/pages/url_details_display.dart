import 'package:QRScanGenerate/ad/ad_mob.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:QRScanGenerate/Widget/banner_ad.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Widget/custom_icon.dart';
import '../utils/appcolor.dart';
import '../utils/function.dart';

class UrlDetailsPage extends StatefulWidget {
  final url;
  const UrlDetailsPage({super.key, required this.url});

  @override
  State<UrlDetailsPage> createState() => _UrlDetailsPageState();
}

class _UrlDetailsPageState extends State<UrlDetailsPage> {
  InterstitialAd? _interstitalAd;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createInterstitialAd();
  }

  void createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdMobServices.interstitialAdUniId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _interstitalAd = ad;
          },
          onAdFailedToLoad: (error) {
            _interstitalAd = null;
            print(error);
          },
        ));
  }

  void _showInterstitalAd() {
    if (_interstitalAd != null) {
      _interstitalAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          createInterstitialAd();
        },
      );
      _interstitalAd!.show();
      _interstitalAd = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    void launchURL(Uri url) {
      try {
        launchUrl(url);
      } catch (e) {
        showMsg(context, "Failed to launch URL: $e");
      }
    }

    void copyUrl() {
      showMsg(context, "Copied!");
      _showInterstitalAd();
      FlutterClipboard.copy(widget.url.toString());
    }

    void shareData(BuildContext context) {
      final String message = 'Check out this link: ${widget.url}';
      Share.share(message)
          .then((value) => print('Shared successfully'))
          .catchError((error) => print('Error sharing: $error'));
    }

    return Scaffold(
      bottomNavigationBar: BannerAdWidget(),
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: const Text(
          "Scanned Data",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: AppColors.mainColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(17),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 100,
                      child: Text(
                        softWrap: true,
                        widget.url.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 19),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomIconButton(
                      icon: Icons.copy, label: "Copy", onTap: () => copyUrl()),
                  CustomIconButton(
                    icon: Icons.open_in_browser,
                    label: "Open Link",
                    onTap: () {
                      if (widget.url is String) {
                        launchURL(Uri.parse(widget.url));
                      } else {
                        launchURL(widget.url);
                      }
                    },
                  ),
                  CustomIconButton(
                      icon: Icons.share,
                      label: "Share",
                      onTap: () => shareData(context)),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.09),
              SizedBox(
                child: BannerAdWidget(),
              ),
              GestureDetector(
                onTap: () {
                  launchURL(widget.url);
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 96, 125, 139),
                      borderRadius: BorderRadius.circular(20)),
                  child: const Center(
                      child: Text("Open Link",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white))),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
