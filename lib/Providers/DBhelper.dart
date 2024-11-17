// import 'package:sqlite3/sqlite3.dart';

// class DBHelper {
//   late Database db;

//   DBHelper() {
//     db = sqlite3
//         .openInMemory(); // Replace with a file path for persistent storage
//     _createTables();
//   }

//   // Create the profiles table with isMyProfile field
//   void _createTables() {
//     db.execute('''
//       CREATE TABLE IF NOT EXISTS profiles (
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         name TEXT NOT NULL,
//         profession TEXT,
//         email TEXT,
//         phoneNumber TEXT,
//         instagram TEXT,
//         linkedin TEXT,
//         twitter TEXT,
//         isMyProfile INTEGER NOT NULL
//       );
//     ''');
//   }

//   // Insert a new profile
//   void insertProfile(Map<String, dynamic> profile) {
//     final stmt = db.prepare(
//         'INSERT INTO profiles (name, profession, email, phoneNumber, instagram, linkedin, twitter, isMyProfile) VALUES (?, ?, ?, ?, ?, ?, ?, ?)');
//     stmt.execute([
//       profile['name'],
//       profile['profession'],
//       profile['email'],
//       profile['phoneNumber'],
//       profile['instagram'],
//       profile['linkedin'],
//       profile['twitter'],
//       profile['isMyProfile'] ? 1 : 0,
//     ]);
//     stmt.dispose();
//   }

//   // Get all profiles
//   List<Map<String, dynamic>> getProfiles() {
//     final resultSet = db.select('SELECT * FROM profiles');
//     List<Map<String, dynamic>> profiles = [];
//     for (final row in resultSet) {
//       profiles.add({
//         'id': row['id'],
//         'name': row['name'],
//         'profession': row['profession'],
//         'email': row['email'],
//         'phoneNumber': row['phoneNumber'],
//         'instagram': row['instagram'],
//         'linkedin': row['linkedin'],
//         'twitter': row['twitter'],
//         'isMyProfile': row['isMyProfile'] == 1,
//       });
//     }
//     return profiles;
//   }

//   // Update a profile
//   void updateProfile(int id, Map<String, dynamic> profile) {
//     final stmt = db.prepare('''
//       UPDATE profiles SET name = ?, profession = ?, email = ?, phoneNumber = ?, instagram = ?, linkedin = ?, twitter = ?, isMyProfile = ?
//       WHERE id = ?
//     ''');
//     stmt.execute([
//       profile['name'],
//       profile['profession'],
//       profile['email'],
//       profile['phoneNumber'],
//       profile['instagram'],
//       profile['linkedin'],
//       profile['twitter'],
//       profile['isMyProfile'] ? 1 : 0,
//       id,
//     ]);
//     stmt.dispose();
//   }

//   // Delete a profile by id
//   void deleteProfile(int id) {
//     final stmt = db.prepare('DELETE FROM profiles WHERE id = ?');
//     stmt.execute([id]);
//     stmt.dispose();
//   }

//   // Get only "my" profiles
//   List<Map<String, dynamic>> getMyProfiles() {
//     final resultSet = db.select('SELECT * FROM profiles WHERE isMyProfile = 1');
//     return _mapResultSet(resultSet);
//   }

//   // Get only other profiles
//   List<Map<String, dynamic>> getOtherProfiles() {
//     final resultSet = db.select('SELECT * FROM profiles WHERE isMyProfile = 0');
//     return _mapResultSet(resultSet);
//   }

//   List<Map<String, dynamic>> _mapResultSet(ResultSet resultSet) {
//     return resultSet.map((row) {
//       return {
//         'id': row['id'],
//         'name': row['name'],
//         'profession': row['profession'],
//         'email': row['email'],
//         'phoneNumber': row['phoneNumber'],
//         'instagram': row['instagram'],
//         'linkedin': row['linkedin'],
//         'twitter': row['twitter'],
//         'isMyProfile': row['isMyProfile'] == 1,
//       };
//     }).toList();
//   }

//   // Dispose the database when done
//   void dispose() {
//     db.dispose();
//   }
// }

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _database;

  // Initialize or get existing database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Open database connection
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'profiles.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE profiles (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            profession TEXT,
            email TEXT,
            phoneNumber TEXT,
            instagram TEXT,
            linkedin TEXT,
            twitter TEXT,
            isMyProfile INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  // Insert a new profile
  Future<void> insertProfile(Map<String, dynamic> profile) async {
    final db = await database;
    print(profile['name']);
    await db.insert(
      'profiles',
      {
        'name': profile['name'],
        'profession': profile['profession'],
        'email': profile['email'],
        'phoneNumber': profile['phoneNumber'],
        'instagram': profile['instagram'],
        'linkedin': profile['linkedin'],
        'twitter': profile['twitter'],
        'isMyProfile': profile['isMyProfile'] ? 1 : 0,
      },
    );
  }

  // Get a specific profile by ID
  Future<Map<String, dynamic>?> getProfileById(int id) async {
    final db = await database;
    final resultSet =
        await db.query('profiles', where: 'id = ?', whereArgs: [id]);
    if (resultSet.isNotEmpty) {
      return resultSet.first;
    }
    return null;
  }

  // Update a profile by ID
  Future<void> updateProfile(int id, Map<String, dynamic> profile) async {
    final db = await database;
    await db.update(
      'profiles',
      {
        'name': profile['name'],
        'profession': profile['profession'],
        'email': profile['email'],
        'phoneNumber': profile['phoneNumber'],
        'instagram': profile['instagram'],
        'linkedin': profile['linkedin'],
        'twitter': profile['twitter'],
        'isMyProfile': profile['isMyProfile'] ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Get user ID based on profile type (my profile or not)
  Future<int> getUserIdByProfileType(bool isMyProfile) async {
    final db = await database;
    final resultSet = await db.query(
      'profiles',
      columns: ['id'],
      where: 'isMyProfile = ?',
      whereArgs: [isMyProfile ? 1 : 0],
    );
    if (resultSet.isNotEmpty) {
      return resultSet.first['id'] as int;
    }
    return -1; // Returns -1 if no profile found
  }

  // Get user ID by email
  Future<int> getUserIdByEmail(String email) async {
    final db = await database;
    final resultSet = await db.query(
      'profiles',
      columns: ['id'],
      where: 'email = ?',
      whereArgs: [email],
    );
    if (resultSet.isNotEmpty) {
      return resultSet.first['id'] as int;
    }
    return -1; // Returns -1 if no user found
  }

  // Delete a profile by ID
  Future<void> deleteProfile(int id) async {
    final db = await database;
    await db.delete('profiles', where: 'id = ?', whereArgs: [id]);
  }

  // Clear all profiles
  Future<void> clearProfiles() async {
    final db = await database;
    await db.delete('profiles');
  }

  // Get only "my" profiles
  Future<List<Map<String, dynamic>>> getMyProfiles() async {
    final db = await database;
    return await db.query('profiles', where: 'isMyProfile = ?', whereArgs: [1]);
  }

  // Get only other profiles
  Future<List<Map<String, dynamic>>> getOtherProfiles() async {
    final db = await database;
    return await db.query('profiles', where: 'isMyProfile = ?', whereArgs: [0]);
  }

  // Dispose the database when done
  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
  }
}












// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

// class QRScannerPage extends StatefulWidget {
//   const QRScannerPage({Key? key}) : super(key: key);

//   @override
//   State<StatefulWidget> createState() => _QRScannerPageState();
// }

// class _QRScannerPageState extends State<QRScannerPage> {
//   Barcode? result;
//   QRViewController? controller;
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

//   @override
//   void reassemble() {
//     super.reassemble();
//     if (Platform.isAndroid) {
//       controller?.pauseCamera();
//     }
//     controller?.resumeCamera();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("QR Scanner"),
//         backgroundColor: Colors.black,
//       ),
//       body: Column(
//         children: <Widget>[
//           Expanded(flex: 4, child: _buildQrView(context)),
//           const Expanded(
//             flex: 1,
//             child: Center(
//               child: const Text(
//                 "Scan a QR Code",
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//   // bool isTripleQuoted(String str) {
//   //     return str.startsWith("'''") && str.endsWith("'''");
//   //   }

//   //   // Check for single quotes by context (this test won't work exactly in Dart's runtime but demonstrates logic)
//   //   bool isSingleQuoted(String str) {
//   //     return !isTripleQuoted(str); // Fallback logic for single-quoted strings
//   //   }
//   Widget _buildQrView(BuildContext context) {
//     var scanArea = (MediaQuery.of(context).size.width < 400 ||
//             MediaQuery.of(context).size.height < 400)
//         ? 200.0
//         : 300.0;
//     return QRView(
//       key: qrKey,
//       onQRViewCreated: _onQRViewCreated,
//       overlay: QrScannerOverlayShape(
//         borderColor: Colors.red,
//         borderRadius: 10,
//         borderLength: 30,
//         borderWidth: 10,
//         cutOutSize: scanArea,
//       ),
//       onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
//     );
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     setState(() {
//       this.controller = controller;
//     });

//     controller.scannedDataStream.listen((scanData) {
//       print("Scanned QR Code: ${scanData.code}");

//       setState(() {
//         result = scanData;
//       });

//       if (result != null) {
//         try {
//           // Ensure raw input is used for decoding
//           String rawData = scanData.code ?? "";

//           // Parse the JSON string
//           Map<String, String> dataMap = jsonDecode(rawData);
//           print("Decoded Data Map: $dataMap");

//           // Pause the camera to prevent additional scans
//           controller.pauseCamera();

//           // Navigate to the ProfileCard page with the parsed data
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => ProfileCard(profileData: dataMap),
//             ),
//           );
//         } catch (e) {
//           // Handle any parsing errors gracefully
//           print("Error decoding QR data: $e");
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("Invalid QR Code")),
//           );
//         }
//       }
//     });
//   }

//   void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
//     log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
//     if (!p) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('No Permission')),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }
// }

// class ProfileCard extends StatelessWidget {
//   final Map<String, String> profileData;

//   const ProfileCard({Key? key, required this.profileData}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Profile Details"),
//         backgroundColor: Colors.black,
//       ),
//       body: Center(
//         child: Card(
//           margin: const EdgeInsets.all(16),
//           elevation: 8,
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   profileData["name"] ?? "N/A",
//                   style: const TextStyle(
//                       fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   profileData["profession"] ?? "N/A",
//                   style: const TextStyle(fontSize: 18, color: Colors.grey),
//                 ),
//                 const Divider(),
//                 _buildDetailRow("Email", profileData["email"]),
//                 _buildDetailRow("Phone", profileData["phoneNumber"]),
//                 _buildDetailRow("Instagram", profileData["instagram"]),
//                 _buildDetailRow("LinkedIn", profileData["linkedin"]),
//                 _buildDetailRow("Twitter", profileData["twitter"]),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailRow(String title, String? value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
//           Text(value ?? "N/A"),
//         ],
//       ),
//     );
//   }
// }
