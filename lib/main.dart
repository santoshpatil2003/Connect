import 'package:connect/Pages/OtherProfilesPage.dart';
import 'package:connect/Pages/ProfilePage.dart';
import 'package:connect/Providers/ProfileProvider.dart';
import 'package:connect/Providers/ProviderSQL.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final screens = [ProfilePage(), const OtherProfilesPage()];
  int i = 0;
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   setState(() {
  //     i = 0;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider2()),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: screens[i],
          bottomNavigationBar: BottomNavigationBar(
            onTap: (value) {
              setState(() {
                i = value;
              });
            },
            backgroundColor: Colors.black,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: const TextStyle(color: Colors.white),
            unselectedLabelStyle: const TextStyle(color: Colors.grey),
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person_2_rounded,
                  color: Colors.white,
                  size: 30,
                ),
                label: 'Profile',
              ),
              // BottomNavigationBarItem(
              //   icon: Icon(Icons.connect_without_contact_rounded,
              //       size: 30, color: Colors.white),
              //   label: 'Connections',
              // ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icons/Connect Icon3.png',
                  width: 40, // Adjust width as needed
                  height: 40, // Adjust height if necessary
                  fit: BoxFit
                      .contain, // You can adjust the fit to control how the image is scaled
                ),
                label: 'Connections',
              )

              // BottomNavigationBarItem(
              //   icon: Icon(Icons.chat, color: Colors.white),
              //   label: 'Chats',
              // ),
            ],
          ),
        ),
        // home: QrDisplayPage(data: "${profileData}"),
        // home: QRScannerPage(),
      ),
    );

    // ChangeNotifierProvider(
    //   create: (_) => ProfileProvider(),
    //   child: MaterialApp(
    //     home: ProfilePage(),
    //     // home: QrDisplayPage(data: "${profileData}"),
    //     // home: QRScannerPage(),
    //   ),
    // );
  }
}
