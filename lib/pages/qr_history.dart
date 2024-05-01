import 'package:QRScanGenerate/ad/ad_mob.dart';
import 'package:QRScanGenerate/utils/function.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:QRScanGenerate/Widget/banner_ad.dart';
import 'package:QRScanGenerate/pages/url_details_display.dart';
import 'package:QRScanGenerate/utils/appcolor.dart';

import '../database/qr_code_history.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<QRCodeHistory>> _qrCodeHistory;
  InterstitialAd? _interstitalAd;
  RewardedAd? _rewardedAd;
  @override
  void initState() {
    super.initState();
    _qrCodeHistory = DatabaseHelper.getQRCodeHistory();
    createInterstitialAd();
    createRewardAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SecondBannerAdWidget(),
      backgroundColor: AppColors.mainColor,
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: const Text("History"),
      ),
      body: FutureBuilder(
        future: _qrCodeHistory,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<QRCodeHistory> qrCodeHistoryList =
                (snapshot.data as List<QRCodeHistory>).reversed.toList();
            if (qrCodeHistoryList.isEmpty) {
              return const Center(
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: Text(
                    "No History !",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        fontFamily: "Roboto"),
                  ),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: qrCodeHistoryList.length,
                itemBuilder: (context, index) {
                  QRCodeHistory qrCodeHistory = qrCodeHistoryList[index];
                  String formattedDateTime = DateFormat('dd/MM/yyyy HH:mm')
                      .format(qrCodeHistory.scannedAt);
                  return SwipeActionCell(
                    backgroundColor: AppColors.mainColor,
                    key: ObjectKey(qrCodeHistory),
                    trailingActions: [
                      SwipeAction(
                        color: const Color.fromARGB(255, 147, 172, 184),
                        content: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        onTap: (handler) async {
                          await handler(true);
                          _deleteItem(qrCodeHistory);
                          // createRewardAd();
                          _showRewardAd();
                          // _showInterstitalAd();
                        },
                        backgroundRadius: 10,
                      ),
                    ],
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color.fromARGB(255, 164, 179, 186),
                        ),
                        child: ListTile(
                          trailing: const Text("<-- Swipe Left"),
                          leading: const Icon(Icons.qr_code),
                          title: Text(
                            qrCodeHistory.qrData,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(formattedDateTime),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UrlDetailsPage(
                                  url: qrCodeHistory.qrData,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }

  void _deleteItem(QRCodeHistory qrCodeHistory) async {
    try {
      await DatabaseHelper.deleteQRCodeHistory(qrCodeHistory);
      setState(() {
        _qrCodeHistory = DatabaseHelper.getQRCodeHistory();
        showMsg(context, "Delete SuccessFully");
      });
    } catch (e) {
      print('Error deleting item: $e');
    }
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

  void _showRewardAd() {
    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          createRewardAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          createRewardAd();
        },
      );
      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          setState(() {});
        },
      );

      _rewardedAd = null;
    }
  }

  void createRewardAd() {
    RewardedAd.load(
        adUnitId: AdMobServices.rewardAd!,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
          print("+++++++++++++++++++++++++++");
          setState(() {
            _rewardedAd = ad;
          });
        }, onAdFailedToLoad: (error) {
          print("****************");
          _rewardedAd = null;
        }));
  }
}
