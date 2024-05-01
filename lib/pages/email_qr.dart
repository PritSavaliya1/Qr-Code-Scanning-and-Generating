import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class EmailQRCodeGenerator extends StatelessWidget {
  final String recipientEmail;
  final String subject;
  final String body;

  EmailQRCodeGenerator({
    required this.recipientEmail,s
    required this.subject,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    String emailData = 'mailto:$recipientEmail?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}';

    return Scaffold(
      appBar: AppBar(
        title: Text('Email QR Code'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
              data: emailData,
              version: QrVersions.auto,
              size: 200.0,
            ),
            SizedBox(height: 20),
            Text(
              'Scan this QR code to send an email',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
