import 'package:QRScanGenerate/ad/ad_mob.dart';
import 'package:QRScanGenerate/utils/function.dart';
import 'package:flutter/material.dart';
import 'package:QRScanGenerate/Widget/banner_ad.dart';
import 'package:get/get.dart';
import '../../Widget/custom_button.dart';
import '../../Widget/custom_texform.dart';
import '../../database/qr_code_history.dart';
import '../generted_page.dart';

class TextQr extends StatefulWidget {
  const TextQr({Key? key}) : super(key: key);

  @override
  _TextQrState createState() => _TextQrState();
}

class _TextQrState extends State<TextQr> {
  final TextEditingController textController = TextEditingController();
  String textData = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _validateForm() {
    return _formKey.currentState!.validate();
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
                "Enter Text",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              CustomInputField(
                textInputType: TextInputType.text,
                controller: textController,
                labelText: "Text",
                maxline: 6,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              CustomButton(
                onTap: () {
                  if (_validateForm()) {
                    setState(() {
                      textData = textController.text;
                    });
                    DatabaseHelper.insertQRCodeHistory(QRCodeHistory(
                      qrData: textData,
                      scannedAt: DateTime.now(),
                    ));
                    Get.off(GeneratedData(generatedData: textData));
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

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
