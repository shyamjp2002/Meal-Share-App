import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class QRCodeScannerApp extends StatefulWidget {
  final CameraDescription camera;

  const QRCodeScannerApp({Key? key, required this.camera}) : super(key: key);

  @override
  _QRCodeScannerAppState createState() => _QRCodeScannerAppState();
}

class _QRCodeScannerAppState extends State<QRCodeScannerApp> {
  late CameraController _controller;
  late QRViewController _qrController;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String scannedData = '';

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.high);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Container();
    }
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('QR Code Scanner'),
        ),
        body: Stack(
          children: [
            CameraPreview(_controller),
            Positioned.fill(
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 4,
              left: MediaQuery.of(context).size.width / 4,
              right: MediaQuery.of(context).size.width / 4,
              bottom: MediaQuery.of(context).size.height / 4,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.red,
                    width: 2.0,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 16.0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(16.0),
                color: Colors.black54,
                child: Text(
                  'Scanned Data: $scannedData',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    _qrController = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        scannedData = scanData.code.toString();
      });
      _processScannedData(
          scannedData); // Call your function here with the scanned data
    });
  }

  void _processScannedData(String data) {
    markAttendance(context, data,
        true); // Mark attendance with scannedData as the inmateId
  }

  Future<void> markAttendance(
      BuildContext context, String inmateId, bool isPresent) async {
    try {
      final adminHostelSnapshot = await FirebaseFirestore.instance
          .collection('hostel_admins')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .limit(1)
          .get();
      final adminHostelName = adminHostelSnapshot.docs.first.get('hostel');

      final inmateSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: inmateId)
          .limit(1)
          .get();
      final inmateHostelName = inmateSnapshot.docs.first.get('hostel');

      final currentDate = DateTime.now();
      final formattedDateString = DateFormat('dd-MM-yy').format(currentDate);

      final attendanceRef = FirebaseFirestore.instance
          .collection('Attendance')
          .doc(formattedDateString)
          .collection(adminHostelName);

      final dateDoc = FirebaseFirestore.instance
          .collection('Attendance')
          .doc(formattedDateString);

      final dateDocSnapshot = await dateDoc.get();

      if (!dateDocSnapshot.exists) {
        await dateDoc.set({});
      }

      final hostelNameCollectionSnapshot =
          await dateDoc.collection(adminHostelName).limit(1).get();

      if (hostelNameCollectionSnapshot.docs.isEmpty) {
        if (adminHostelName == inmateHostelName) {
          await attendanceRef.doc(inmateId).set({
            'present': isPresent,
            'timestamp': FieldValue.serverTimestamp(),
          });
          print('Attendance marked successfully!');
        } else {
          print('Inmate does not belong to the admin\'s hostel.');
        }
      } else {
        final snapshot = await attendanceRef.doc(inmateId).get();

        if (!snapshot.exists) {
          await attendanceRef.doc(inmateId).set({
            'present': isPresent,
            'timestamp': FieldValue.serverTimestamp(),
          });
          print('Attendance marked successfully!');
        } else if (snapshot.exists && snapshot.get('present')) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Already Marked'),
                content: Text('This student is already marked present.'),
                actions: [
                  ElevatedButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          print('Attendance is already marked but with a different status.');
        }
      }
    } catch (error) {
      print('Error marking attendance: $error');
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  runApp(QRCodeScannerApp(camera: firstCamera));
}
