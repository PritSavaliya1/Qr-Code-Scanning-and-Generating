import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'pages/qr_scanner.dart';

class PermissionHandler extends StatefulWidget {
  @override
  _PermissionHandlerState createState() => _PermissionHandlerState();
}

class _PermissionHandlerState extends State<PermissionHandler> {
  late PermissionStatus _status = PermissionStatus.denied;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    _status = await Permission.camera.status;
    if (_status.isDenied) {
      _status = await Permission.camera.request();
    } else {}
    if (_status.isGranted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => QRScannerScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Permission Handler'),
      ),
      body: Center(
        child: _status.isGranted
            ? const Text('Camera permission granted, redirecting...')
            : Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      _requestCameraPermission();
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 96, 125, 139),
                          borderRadius: BorderRadius.circular(20)),
                      child: const Center(
                          child: Text("Give Access",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white))),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text('Camera permission not granted.'),
                ],
              ),
      ),
    );
  }
}
