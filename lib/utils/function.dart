import 'dart:io';
import 'dart:typed_data';

import 'package:QRScanGenerate/ad/ad_mob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';

void showMsg(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(seconds: 1),
    ),
  );
}

Future<bool> checkForQrCode(Uint8List bytes) async {
  final tempDir = await getTemporaryDirectory();
  final tempPath = tempDir.path;
  final tempFile = File('$tempPath/temp_image.jpg');
  await tempFile.writeAsBytes(bytes);
  final qrText = await FlutterQrReader.imgScan(tempFile.path);
  return qrText != null;
}

  void createBannerAd() {
    BannerAd banner;
    banner = BannerAd(size: AdSize.fullBanner,
    adUnitId: AdMobServices.bannerAdUnitID!,
    listener: AdMobServices.bannerAdListener!, request: const AdRequest())..load();
  }