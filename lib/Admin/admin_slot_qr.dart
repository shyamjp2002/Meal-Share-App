import 'package:flutter/material.dart';
import './admin_qr_scanner.dart';
import 'package:camera/camera.dart';



class SlotQrView extends StatelessWidget {
  final String mealId;
  final String hostel;
  final String Date;
  final String status;

  SlotQrView({required this.mealId, required this.hostel, required this.Date, required this.status});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'SLOT DETAILS',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Color(0xFF449183),
          centerTitle: true,
        ),
        body: Container(
          color: Color(0xFF1D1F24),
          child: Center(
            child: Container(
              width: 200,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mess: Sahara',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Date: June 1',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Time: 12.30-1.30',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Status: Active',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'ID: #123456789',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            final cameras = await availableCameras();
                      final firstCamera = cameras.first;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                QRCodeScannerApp(camera: firstCamera)),
                      );
          },
          label: Text('NEXT'),
          icon: Icon(Icons.qr_code),
          backgroundColor: Color(0xFF449183),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
