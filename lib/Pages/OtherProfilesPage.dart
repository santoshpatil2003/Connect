// import 'package:connect/Providers/ProviderSQL.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class OtherProfilesPage extends StatefulWidget {
//   const OtherProfilesPage({super.key});

//   @override
//   State<OtherProfilesPage> createState() => _OtherProfilesPageState();
// }

// class _OtherProfilesPageState extends State<OtherProfilesPage> {
//   late Future<List<Map<String, dynamic>>> profilesFuture;
//   late final ProfileProvider2 profileProvider;

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   profilesFuture = getOtherProfiles();
//   // }

//   // Simulating the function that fetches data from SQLite
//   // Future<List<Map<String, dynamic>>> getOtherProfiles() async {
//   //   // Example dummy data for testing. Replace this with actual DB fetch.
//   //   await Future.delayed(const Duration(seconds: 2)); // Simulate delay
//   //   return [
//   //     {
//   //       "name": "Santosh",
//   //       "profession": "Entrepreneur",
//   //       "email": "Santoshpatil2003@gmail.com",
//   //       "phoneNumber": "9845167455",
//   //       "instagram": "santoshpatil2003",
//   //       "linkedin": "santoshpatil2003",
//   //       "twitter": "santoshpatil200"
//   //     },
//   //     {
//   //       "name": "Asha",
//   //       "profession": "Software Engineer",
//   //       "email": "asha123@gmail.com",
//   //       "phoneNumber": "9876543210",
//   //       "instagram": "asha_insta",
//   //       "linkedin": "asha-linkedin",
//   //       "twitter": "asha_tweets"
//   //     }
//   //   ];
//   // }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     // profilesFuture = getOtherProfiles();
//     profileProvider = Provider.of<ProfileProvider2>(context);
//     profilesFuture = profileProvider.getOtherProfiles();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Connections",
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.black,
//       ),
//       backgroundColor: Colors.black,
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: profilesFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text("No profiles available."));
//           } else {
//             final profiles = snapshot.data!;
//             return ListView.builder(
//               itemCount: profiles.length,
//               itemBuilder: (context, index) {
//                 return ProfileCard(
//                   profileData: profiles[index],
//                   provider: profileProvider,
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }

// // Card Widget for displaying profile data
// class ProfileCard extends StatelessWidget {
//   final Map<String, dynamic> profileData;
//   final ProfileProvider2 provider;

//   const ProfileCard(
//       {Key? key, required this.profileData, required this.provider})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // print(profileData['id']);
//     return Card(
//       color: Colors.grey[900],
//       elevation: 5,
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   profileData["name"] ?? "Unknown",
//                   style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white),
//                 ),
//                 PopupMenuButton<int>(
//                   padding: const EdgeInsets.all(0.0),
//                   iconColor: Colors.white,
//                   color: Colors.black,
//                   itemBuilder: (context) => [
//                     PopupMenuItem(
//                       onTap: () {
//                         provider
//                             .deleteProfile(profileData['id'])
//                             .then((onValue) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(content: Text("Deleted")),
//                           );
//                         });
//                       },
//                       value: 1,
//                       child: const Row(
//                         children: [
//                           SizedBox(
//                             child: Row(
//                               children: [
//                                 Icon(
//                                   Icons.delete,
//                                   color: Colors.white,
//                                 ),
//                                 SizedBox(
//                                   width: 10,
//                                 ),
//                                 Text(
//                                   "Delete",
//                                   style: TextStyle(color: Colors.white),
//                                 )
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             // const SizedBox(height: 0),
//             _buildRow("Profession", profileData["profession"]),
//             _buildRow("Email", profileData["email"]),
//             _buildRow("Phone", profileData["phoneNumber"]),
//             _buildRow("Instagram", profileData["instagram"]),
//             _buildRow("LinkedIn", profileData["linkedin"]),
//             _buildRow("Twitter", profileData["twitter"]),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRow(String label, String? value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         children: [
//           Text(
//             "$label: ",
//             style: const TextStyle(
//                 fontWeight: FontWeight.bold, color: Colors.white),
//           ),
//           Flexible(
//             child: Text(
//               value ?? "N/A",
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:connect/Providers/ProviderSQL.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OtherProfilesPage extends StatefulWidget {
  const OtherProfilesPage({super.key});

  @override
  State<OtherProfilesPage> createState() => _OtherProfilesPageState();
}

class _OtherProfilesPageState extends State<OtherProfilesPage> {
  late ProfileProvider2 profileProvider;

  @override
  void initState() {
    super.initState();
    // Move the provider initialization to initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileProvider = Provider.of<ProfileProvider2>(context, listen: false);
      // Trigger initial load
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Connections",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Consumer<ProfileProvider2>(
        builder: (context, provider, child) {
          return FutureBuilder<List<Map<String, dynamic>>>(
            future: provider.getOtherProfiles(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    "No profiles available.",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ProfileCard(
                    profileData: snapshot.data![index],
                    provider: provider,
                    onDelete: () async {
                      // Handle delete with proper state update
                      try {
                        await provider
                            .deleteProfile(snapshot.data![index]['id']);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Profile deleted successfully")),
                          );
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text("Error deleting profile: $e")),
                          );
                        }
                      }
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final Map<String, dynamic> profileData;
  final ProfileProvider2 provider;
  final VoidCallback onDelete;

  const ProfileCard({
    Key? key,
    required this.profileData,
    required this.provider,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  profileData["name"] ?? "Unknown",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                PopupMenuButton<int>(
                  padding: const EdgeInsets.all(0.0),
                  iconColor: Colors.white,
                  color: Colors.black,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      onTap: onDelete,
                      child: const Row(
                        children: [
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Delete",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            _buildRow("Profession", profileData["profession"]),
            _buildRow("Email", profileData["email"]),
            _buildRow("Phone", profileData["phoneNumber"]),
            _buildRow("Instagram", profileData["instagram"]),
            _buildRow("LinkedIn", profileData["linkedin"]),
            _buildRow("Twitter", profileData["twitter"]),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Flexible(
            child: Text(
              value ?? "N/A",
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
