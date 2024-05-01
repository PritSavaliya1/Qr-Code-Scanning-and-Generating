import 'package:QRScanGenerate/ad/ad_mob.dart';
import 'package:flutter/material.dart';
import 'package:QRScanGenerate/Widget/banner_ad.dart';
import 'package:get/get.dart';
import '../../Widget/custom_button.dart';
import '../../Widget/custom_texform.dart';
import '../../database/qr_code_history.dart';
import '../../utils/function.dart';
import '../generted_page.dart';

class NumQR extends StatefulWidget {
  const NumQR({Key? key}) : super(key: key);

  @override
  _NumQRState createState() => _NumQRState();
}

class _NumQRState extends State<NumQR> {
  final TextEditingController phoneNumberController = TextEditingController();
  String phoneNumberData = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number cannot be empty';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Please enter a valid phone number';
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
                "Enter Mobile Number",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              CustomInputField(
                maxlength: 10,
                textInputType: TextInputType.number,
                controller: phoneNumberController,
                labelText: "Phone no",
                maxline: 1,
                validator: validatePhoneNumber,
              ),
              SizedBox(height: 10.0),
              CustomButton(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      String phoneNumber = phoneNumberController.text;
                      phoneNumberData = 'tel:$phoneNumber';
                    });
                    DatabaseHelper.insertQRCodeHistory(QRCodeHistory(
                        qrData: phoneNumberData, scannedAt: DateTime.now()));
                    Get.off(GeneratedData(generatedData: phoneNumberData));
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
    phoneNumberController.clear();
    super.dispose();
  }
}
