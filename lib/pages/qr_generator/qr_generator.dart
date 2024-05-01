import 'package:QRScanGenerate/ad/ad_mob.dart';
import 'package:QRScanGenerate/utils/function.dart';
import 'package:flutter/material.dart';
import 'package:QRScanGenerate/Widget/banner_ad.dart';
import 'package:QRScanGenerate/pages/genetor/number_qr.dart';

import '../genetor/email_qr.dart';
import '../genetor/sms_qr.dart';
import '../genetor/text_qr.dart';

class QrGenerator extends StatefulWidget {
  const QrGenerator({super.key});

  @override
  State<QrGenerator> createState() => _QrGeneratorState();
}

class _QrGeneratorState extends State<QrGenerator> {
    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createBannerAd();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BannerAdWidget(),
      appBar: AppBar(
        title: Text(
          "Qr Code Generator",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left:50,right: 50,top: 30,bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomContainer(context,Icons.email,() {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>EmailQR()));
                    },),
                    CustomContainer(context,Icons.call,() {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>NumQR()));
                    },),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:50,right: 50,top: 30,bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomContainer(context,Icons.message,() {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SmsQr()));
                    },),
                    CustomContainer(context,Icons.edit,() {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>TextQr()));
                    },),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget CustomContainer(
      BuildContext context, IconData icon, VoidCallback ontap) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(20)),
        child: Icon(
          icon,
          size: 28,
          color: Colors.blueGrey,
        ),
      ),
    );
  }
}
