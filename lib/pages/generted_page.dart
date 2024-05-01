import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:QRScanGenerate/ad/ad_mob.dart';
import 'package:QRScanGenerate/utils/function.dart';
import 'package:share_plus/share_plus.dart';
import '../utils/appcolor.dart';
import '../widget/custom_icon.dart';

class GeneratedData extends StatefulWidget {
  final String generatedData;

  GeneratedData({Key? key, required this.generatedData}) : super(key: key);

  @override
  State<GeneratedData> createState() => _GeneratedDataState();
}

class _GeneratedDataState extends State<GeneratedData> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createBannerAd();
    createInterstitialAd();
  }
  void createBannerAd() {
    banner = BannerAd(size: AdSize.fullBanner,
    adUnitId: AdMobServices.secondBannerAdUnitId!,
    listener: AdMobServices.bannerAdListener!, request: const AdRequest())..load();
  }
  final GlobalKey _qrImageKey = GlobalKey();
  Future<Directory?>? _downloadsDirectory;
  late BannerAd banner;
  InterstitialAd? _interstitalAd;
  Future<void> _saveQrImage() async {
    try {
      await Future.delayed(Duration(milliseconds: 500));

      RenderRepaintBoundary? boundary = _qrImageKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary != null) {
        ui.Image image = await boundary.toImage(pixelRatio: 3.0);
        ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
        if (byteData != null) {
          Uint8List pngBytes = byteData.buffer.asUint8List();
          Directory? downloadsDirectory = await getDownloadsDirectory();
          if (downloadsDirectory != null) {
            String filePath =
                '/storage/emulated/0/Download/qr_code_${DateTime.now().millisecondsSinceEpoch}.png';
            File file = File(filePath);
            await file.writeAsBytes(pngBytes);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('QR code saved to Downloads')),
            );
          } else {
            print('Error: Downloads directory is null');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to save QR code')),
            );
          }
        } else {
          print('Error: ByteData is null');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save QR code')),
          );
        }
      } else {
        print('Error: RenderRepaintBoundary is null');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save QR code')),
        );
      }
    } catch (e) {
      print('Error saving QR code image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save QR code')),
      );
    }
  }

  void _shareData() {
    final String message = 'Check out this link: ${widget.generatedData}';
    Share.share(message)
        .then((value) => print('Shared successfully'))
        .catchError((error) => print('Error sharing: $error'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: banner == null
          ? Container()
          : Container(
              margin: const EdgeInsets.only(bottom: 12),
              height: 52,
              child: AdWidget(ad: banner),
            ),
      backgroundColor: AppColors.mainColor,
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: const Text("QR Code"),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RepaintBoundary(
                key: _qrImageKey,
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(16.0),
                  child: QrImageView(
                    data: widget.generatedData,
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomIconButton(
                    icon: Icons.save,
                    label: "Save",
                    onTap: () {
                      _saveQrImage();
                      _showInterstitalAd();
                    },
                  ),
                  CustomIconButton(
                    icon: Icons.share,
                    label: "Share",
                    onTap: _shareData,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdMobServices.interstitialAdUniId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: 
      (ad) {
        _interstitalAd = ad;
      },
      onAdFailedToLoad: (error) {
        _interstitalAd = null;
        print(error);
      },));
  }
  
  void _showInterstitalAd() {
    if(_interstitalAd!=null){
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
}
