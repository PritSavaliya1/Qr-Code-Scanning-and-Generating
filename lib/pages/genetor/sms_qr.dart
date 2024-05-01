import 'package:QRScanGenerate/ad/ad_mob.dart';
import 'package:QRScanGenerate/utils/function.dart';
import 'package:flutter/material.dart';
import 'package:QRScanGenerate/Widget/banner_ad.dart';
import 'package:QRScanGenerate/database/qr_code_history.dart';
import 'package:get/get.dart';
import '../../Widget/custom_button.dart';
import '../../Widget/custom_texform.dart';
import '../generted_page.dart';

class SmsQr extends StatefulWidget {
  const SmsQr({Key? key}) : super(key: key);

  @override
  _SmsQrState createState() => _SmsQrState();
}

class _SmsQrState extends State<SmsQr> {
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  String smsData = '';

  String? phoneNumberValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    return null; 
  }

  String? messageValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Message is required';
    }
    return null; 
  }
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
                "Enter SMS Details",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              CustomInputField(
                textInputType: TextInputType.phone,
                controller: phoneNumberController,
                labelText: "Recipient Phone",
                maxline: 1,
                validator: phoneNumberValidator,
                maxlength: 10,
              ),
              SizedBox(height: 10),
              CustomInputField(
                textInputType: TextInputType.text,
                controller: messageController,
                labelText: "Message",
                maxline: 5,
                validator: messageValidator,
              ),
              SizedBox(height: 10.0),
              CustomButton(
                onTap: () {
                  if (_validateForm()) {
                    setState(() {
                      String recipientPhoneNumber = phoneNumberController.text;
                      String message = messageController.text;
                      smsData =
                          'sms:$recipientPhoneNumber?body=${Uri.encodeComponent(message)}';
                    });
                    DatabaseHelper.insertQRCodeHistory(QRCodeHistory(
                        qrData: smsData, scannedAt: DateTime.now()));                
                    Get.off(GeneratedData(generatedData: smsData));
                  }
                },
                text: "Generate QR Code",
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }

  bool _validateForm() {
    if (_formKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    phoneNumberController.dispose();
    messageController.dispose();
    super.dispose();
  }
}
