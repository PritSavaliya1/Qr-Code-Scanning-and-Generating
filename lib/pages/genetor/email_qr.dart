import 'package:QRScanGenerate/ad/ad_mob.dart';
import 'package:QRScanGenerate/utils/function.dart';
import 'package:flutter/material.dart';
import 'package:QRScanGenerate/Widget/banner_ad.dart';
import 'package:QRScanGenerate/database/qr_code_history.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

import '../../Widget/custom_button.dart';
import '../../Widget/custom_texform.dart';
import '../generted_page.dart';

class EmailQR extends StatefulWidget {
  const EmailQR({Key? key}) : super(key: key);

  @override
  _EmailQRState createState() => _EmailQRState();
}

class _EmailQRState extends State<EmailQR> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  String emailData = '';

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    createBannerAd();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BannerAdWidget(),
      appBar: AppBar(
        title: Text("QR Code Generator"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Enter Email Details",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              CustomInputField(
                textInputType: TextInputType.emailAddress,
                controller: emailController,
                labelText: "Recipient Email",
                maxline: 1,
                validator: (value) {
                  if (value == null || value.isEmpty){
                      return 'Please enter a valid email address';
                  }
                  else if(value.contains('@') && value.contains('.')){
                    return null;
                  }
                  return 'Please enter a valid email address';
                },
              ),
              SizedBox(height: 10.0),
              CustomInputField(
                textInputType: TextInputType.text,
                controller: subjectController,
                labelText: "Subject",
                maxline: 1,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a subject';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10.0),
              CustomInputField(
                textInputType: TextInputType.text,
                controller: bodyController,
                labelText: "Body",
                maxline: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a body';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              CustomButton(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      String recipientEmail = emailController.text;
                      String subject = subjectController.text;
                      String body = bodyController.text;
                      emailData =
                          'mailto:$recipientEmail?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}';
                    });
                    DatabaseHelper.insertQRCodeHistory(QRCodeHistory(
                        qrData: emailData, scannedAt: DateTime.now()));
                    Get.off( GeneratedData(generatedData: emailData));
                  }
                },
                text: "Generate Qr Code",
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    subjectController.dispose();
    bodyController.dispose();
    super.dispose();
  }
}
