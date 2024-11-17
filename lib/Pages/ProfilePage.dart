import 'package:connect/Pages/QrCodeScanner.dart';
import 'package:connect/Pages/QrDisplayPage.dart';
import 'package:connect/Providers/ProviderSQL.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileProvider =
          Provider.of<ProfileProvider2>(context, listen: false);
      _initializeData(profileProvider);
    });
  }

  Future<void> _initializeData(ProfileProvider2 profileProvider) async {
    setState(() => _isLoading = true);

    // if (profileProvider.userId == -1) {
    //   final userid = await profileProvider.fetchAndSetUserId2(true);
    //   if (userid != -1) {
    //     final userData = await profileProvider.loadProfile(userid);
    //     if (userData != null) {
    //       profileProvider.setUserData(userData);
    //     }
    //     print(userData);
    //   }
    // }

    final userid = await profileProvider.fetchAndSetUserId2(true);
    if (userid != -1) {
      final userData = await profileProvider.loadProfile(userid);
      if (userData != null) {
        profileProvider.setUserData(userData);
      }
      print(userData);
    }

    setState(() => _isLoading = false);
  }

  Future<void> _refreshData() async {
    final profileProvider =
        Provider.of<ProfileProvider2>(context, listen: false);
    await _initializeData(profileProvider);
  }

  // @override
  // void didChangeDependencies() {
  //   // TODO: implement didChangeDependencies
  //   super.didChangeDependencies();
  //   final profileProvider =
  //       Provider.of<ProfileProvider2>(context, listen: false);
  //   _initializeData(profileProvider);
  // }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider2>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Connect',
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        backgroundColor: Colors.black,
        actions: [
          // Add refresh button
          IconButton(
            onPressed: _refreshData,
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QRScannerPage()),
              );
            },
            icon: const Icon(
              Icons.qr_code_scanner_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _refreshData,
                child: SingleChildScrollView(
                  physics:
                      const AlwaysScrollableScrollPhysics(), // Enable scrolling even when content is small
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (profileProvider.userId != -1)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: size.width / 0.87,
                              width: size.width / 1.1,
                              child: QrDisplayPage(
                                data: "${profileProvider.UserData}",
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 20),
                      _ProfileCard(profileProvider: profileProvider),
                      const SizedBox(height: 20),
                      if (!profileProvider.isCreated)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: profileProvider.saveProfileData,
                              child: const Text('Create'),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class _ProfileCard extends StatefulWidget {
  final ProfileProvider2 profileProvider;

  const _ProfileCard({required this.profileProvider});

  @override
  State<_ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<_ProfileCard> {
  Widget _buildEditableField(
      String label, String field, String value, BuildContext context) {
    final isEditing = widget.profileProvider.editMode[field] ?? false;
    final size = MediaQuery.of(context).size;

    return Row(
      children: [
        Container(
          height: size.height / 16,
          width: size.width / 1.47,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: isEditing
              ? TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: label,
                    labelStyle: const TextStyle(color: Colors.white54),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  onChanged: (val) {
                    widget.profileProvider.setValue(field, val);
                  },
                )
              : Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value.isNotEmpty ? value : label,
                    style: value.isNotEmpty
                        ? const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            overflow: TextOverflow.ellipsis)
                        : const TextStyle(color: Colors.grey, fontSize: 20),
                  ),
                ),
        ),
        IconButton(
          icon: Icon(
            isEditing ? Icons.check : Icons.edit,
            color: Colors.white54,
          ),
          onPressed: () {
            if (isEditing) {
              widget.profileProvider.updateProfileField(
                  field, value, widget.profileProvider.userId);
            } else {
              widget.profileProvider.toggleEditMode(field);
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (widget.profileProvider.UserData.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      height: size.height / 2,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEditableField(
              widget.profileProvider.userId == -1 ||
                      widget.profileProvider.name == ''
                  ? 'Name'
                  : widget.profileProvider.UserData['name'],
              'name',
              widget.profileProvider.name,
              context),
          _buildEditableField(
              widget.profileProvider.userId == -1 ||
                      widget.profileProvider.profession == ''
                  ? 'Profession'
                  : widget.profileProvider.UserData['profession'],
              'profession',
              widget.profileProvider.profession,
              context),
          _buildEditableField(
              widget.profileProvider.userId == -1 ||
                      widget.profileProvider.email == ''
                  ? 'Email'
                  : widget.profileProvider.UserData['email'],
              'email',
              widget.profileProvider.email,
              context),
          _buildEditableField(
              widget.profileProvider.userId == -1 ||
                      widget.profileProvider.phoneNumber == ''
                  ? 'Phone Number'
                  : widget.profileProvider.UserData['phoneNumber'],
              'phoneNumber',
              widget.profileProvider.phoneNumber,
              context),
          _buildEditableField(
              widget.profileProvider.userId == -1 ||
                      widget.profileProvider.instagram == ''
                  ? 'Instagram'
                  : widget.profileProvider.UserData['instagram'],
              'instagram',
              widget.profileProvider.instagram,
              context),
          _buildEditableField(
              widget.profileProvider.userId == -1 ||
                      widget.profileProvider.linkedin == ''
                  ? 'Linkedin'
                  : widget.profileProvider.UserData['linkedin'],
              'linkedin',
              widget.profileProvider.linkedin,
              context),
          _buildEditableField(
              widget.profileProvider.userId == -1 ||
                      widget.profileProvider.twitter == ''
                  ? 'Twitter'
                  : widget.profileProvider.UserData['twitter'],
              'twitter',
              widget.profileProvider.twitter,
              context),
        ],
      ),
    );
  }
}
