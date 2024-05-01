import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:QRScanGenerate/ad/ad_mob.dart';
import 'package:QRScanGenerate/database/qr_code_history.dart';
import 'package:QRScanGenerate/pages/qr_history.dart';
import 'package:QRScanGenerate/pages/url_details_display.dart';
import 'package:QRScanGenerate/utils/appcolor.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lottie/lottie.dart';

import '../utils/function.dart';
import 'qr_generator/qr_generator.dart';

class QRScannerScreen extends StatefulWidget {
  QRScannerScreen({super.key}) {
    DatabaseHelper.initDatabase();
  }

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final ImagePicker _picker = ImagePicker();

  Uint8List? imageBytes;

  String? qrText;
  late BannerAd banner;
  InterstitialAd? _interstitialAd;

  Future<void> scanQRCode(BuildContext context) async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      "#ff6666",
      "Cancel",
      true,
      ScanMode.QR,
    );

    if (barcodeScanRes != '-1') {
      print('Scanned data: $barcodeScanRes');
      final url = Uri.parse(barcodeScanRes);
      if (url.isAbsolute) {
        DatabaseHelper.insertQRCodeHistory(
            QRCodeHistory(qrData: barcodeScanRes, scannedAt: DateTime.now()));
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UrlDetailsPage(
                      url: url,
                    )));
      } else {
        showMsg(context, 'Scanned data is not a valid URL: $barcodeScanRes');
      }
    } else {
      showMsg(context,'Scanning was cancelled or failed');
    }
  }

  Future<void> _launchURL(Uri url) async {
    if (await launchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> getImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final bool hasQrCode = await checkForQrCode(bytes);
      setState(() {
        imageBytes = bytes;
        qrText = hasQrCode ? 'Scanning QR code...' : null;
      });

      if (hasQrCode) {
        _scanQrCode(pickedFile.path);
      } else {
        showMsg(context, "No QR Found");
      }
    }
  }

  void _scanQrCode(String imagePath) async {
    try {
      final qrText = await FlutterQrReader.imgScan(imagePath);

      if (qrText.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UrlDetailsPage(url: qrText),
          ),
        );
      } else {
        showMsg(context, "No QR code found in the selected image");
      }
    } catch (e) {
      print('Error scanning QR code: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    scanQRCode(context);
    createBannerAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: banner==null?Container():Container(
        margin: const EdgeInsets.only(bottom: 12),
        height: 52,
        child: AdWidget(ad: banner),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => getImageFromGallery(),
        backgroundColor: AppColors.bluegrey,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        tooltip: 'Select Image',
        child: SizedBox(
          width: 60,
          height: 60,
          child: Icon(
            Icons.image,
            size: 40,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: AppColors.mainColor,
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: const Text('QR Code Scanner',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => scanQRCode(context),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: const Color.fromARGB(255, 125, 150, 163)),
                height: 150,
                width: 150,
                child: Lottie.asset('images/camera.json'),
              ),
            ),
            SizedBox(
              height: 100,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HistoryPage()));
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 96, 125, 139),
                    borderRadius: BorderRadius.circular(20)),
                child: const Center(
                    child: Text("History",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white))),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const QrGenerator()));
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 96, 125, 139),
                    borderRadius: BorderRadius.circular(20)),
                child: const Center(
                    child: Text("Qr Code Geneator",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white))),
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
  
  void createBannerAd() {
    banner = BannerAd(size: AdSize.fullBanner,
    adUnitId: AdMobServices.bannerAdUnitID!,
    listener: AdMobServices.bannerAdListener!, request: const AdRequest())..load();
  }
}
