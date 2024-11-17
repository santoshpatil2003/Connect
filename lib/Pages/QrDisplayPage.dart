// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:pretty_qr_code/pretty_qr_code.dart';

// class QrDisplayPage extends StatefulWidget {
//   final String data;

//   QrDisplayPage({required this.data});

//   @override
//   _QrDisplayPageState createState() => _QrDisplayPageState();
// }

// class _QrDisplayPageState extends State<QrDisplayPage> {
//   late QrImage qrImage;

//   @override
//   void initState() {
//     super.initState();
//     final qrCode = QrCode(
//       8,
//       QrErrorCorrectLevel.H,
//     )..addData(widget.data);

//     qrImage = QrImage(qrCode);
//   }

//   Future<void> _saveQrCodeImage() async {
//     // Request storage permission
//     final status = await Permission.storage.request();
//     if (status.isGranted) {
//       // Generate QR code image bytes
//       final qrImageBytes = await qrImage.toImageAsBytes(
//         size: 512,
//         format: ImageByteFormat.png,
//         decoration: PrettyQrDecoration(),
//       );

//       // Convert ByteData to Uint8List
//       final uint8List = Uint8List.view(qrImageBytes!.buffer);

//       // Get the Downloads directory
//       Directory? downloadsDirectory;
//       if (Platform.isAndroid) {
//         downloadsDirectory = Directory('/storage/emulated/0/Download');
//       } else if (Platform.isIOS) {
//         downloadsDirectory =
//             await getApplicationDocumentsDirectory(); // iOS alternative
//       }

//       if (downloadsDirectory != null && await downloadsDirectory.exists()) {
//         final filePath = '${downloadsDirectory.path}/qr_code.png';

//         // Write the file
//         final file = File(filePath);
//         await file.writeAsBytes(uint8List);

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('QR code saved at: $filePath')),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to access the Downloads folder.')),
//         );
//       }
//     } else if (status.isPermanentlyDenied) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text(
//             'Storage permission is permanently denied. Please enable it in settings.',
//           ),
//         ),
//       );
//       await openAppSettings(); // Opens the app settings so the user can manually grant the permission
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Storage permission denied. Unable to save QR code.'),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("QR Code Display"),
//         backgroundColor: Colors.black,
//       ),
//       backgroundColor: Colors.black,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               height: size.width / 1.1,
//               width: size.width / 1.1,
//               color: Colors.white,
//               child: SizedBox(
//                 height: size.width / 1.3,
//                 width: size.width / 1.3,
//                 // color: Colors.white,
//                 child: PrettyQrView(
//                   qrImage: qrImage,
//                   decoration: const PrettyQrDecoration(),
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _saveQrCodeImage,
//               child: Text("Save QR Code"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QrDisplayPage extends StatefulWidget {
  final String data;

  QrDisplayPage({required this.data});

  @override
  _QrDisplayPageState createState() => _QrDisplayPageState();
}

class _QrDisplayPageState extends State<QrDisplayPage> {
  late QrImage qrImage;
  bool hasError = false;
  String errorMessage = '';

  // Function to determine appropriate QR version based on data length
  int _getQrVersion(int dataLength) {
    // Version capacity with error correction level H
    final capacities = {
      14: 1624, // Version 14
      15: 1812, // Version 15
      16: 2032, // Version 16
      // Add more versions if needed
    };

    for (var entry in capacities.entries) {
      if (entry.value >= dataLength) {
        return entry.key;
      }
    }

    // If data is too long for all specified versions, return the highest version (40)
    return 40;
  }

  @override
  void initState() {
    super.initState();
    try {
      final version = _getQrVersion(widget.data.length);
      print(
          'Using QR version: $version for data length: ${widget.data.length}');

      final qrCode = QrCode(
        version,
        QrErrorCorrectLevel.H,
      )..addData(widget.data);

      qrImage = QrImage(qrCode);
    } catch (e) {
      print('QR Generation Error: $e');
      setState(() {
        hasError = true;
        errorMessage = e.toString();
      });
    }
  }

  Future<void> _saveQrCodeImage() async {
    if (hasError) return;

    // Request storage permission
    final status = await Permission.storage.request();
    if (status.isGranted) {
      try {
        // Generate QR code image bytes with custom color
        final qrImageBytes = await qrImage.toImageAsBytes(
          size: 512,
          format: ImageByteFormat.png,
          decoration: const PrettyQrDecoration(
            background: Colors.white,
          ),
        );

        if (qrImageBytes == null) {
          throw Exception('Failed to generate QR image bytes');
        }

        // Convert ByteData to Uint8List
        final uint8List = Uint8List.view(qrImageBytes.buffer);

        // Get the Downloads directory
        Directory? downloadsDirectory;
        if (Platform.isAndroid) {
          downloadsDirectory = Directory('/storage/emulated/0/Download');
        } else if (Platform.isIOS) {
          downloadsDirectory = await getApplicationDocumentsDirectory();
        }

        if (downloadsDirectory != null && await downloadsDirectory.exists()) {
          final filePath = '${downloadsDirectory.path}/custom_qr_code.png';

          // Write the file
          final file = File(filePath);
          await file.writeAsBytes(uint8List);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('QR code saved at: $filePath')),
          );
        } else {
          throw Exception('Downloads directory not accessible');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving QR code: ${e.toString()}')),
        );
      }
    } else if (status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Storage permission is permanently denied. Please enable it in settings.',
          ),
        ),
      );
      await openAppSettings();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Storage permission denied. Unable to save QR code.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Custom QR Code Display",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          children: [
            if (hasError)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error generating QR code: $errorMessage',
                  style: TextStyle(color: Colors.red),
                ),
              )
            else
              Column(
                children: [
                  SizedBox(
                    height: size.width / 1.1,
                    width: size.width / 1.1,
                    child: Card(
                      color: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: PrettyQrView(
                          qrImage: qrImage,
                          decoration: const PrettyQrDecoration(
                            background: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // ElevatedButton(
                  //   onPressed: _saveQrCodeImage,
                  //   child: Text("Save QR Code"),
                  // ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
