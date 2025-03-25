import 'package:expense_tracker/res/colors/app_colors.dart';
import 'package:expense_tracker/viewmodels/auth/auth_viewmodel.dart';
import 'package:expense_tracker/viewmodels/profile/profile_viewmodel.dart';
import 'package:expense_tracker/views/screens/login/login_screen.dart';
import 'package:expense_tracker/views/screens/profile/widgets/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileViewModel>(context, listen: false).loadUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileViewModel = Provider.of<ProfileViewModel>(context);
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: profileViewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Profile picture and name
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Text(
                      profileViewModel.user?.name.substring(0, 1) ?? 'U',
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    profileViewModel.user?.name ?? 'User',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // IconButton(
                  //   icon: const Icon(Icons.edit, size: 20),
                  //   onPressed: () {},
                  // ),
                  const SizedBox(height: 32),

                  // Account options
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        ProfileOption(
                          icon: Icons.account_circle,
                          color: AppColors.secondary,
                          title: 'Account',
                          onTap: () {},
                        ),
                        const Divider(),
                        ProfileOption(
                          icon: Icons.language,
                          color: Colors.grey,
                          title: 'Language',
                          onTap: () {},
                        ),
                        const Divider(),
                        ProfileOption(
                          icon: Icons.fingerprint,
                          color: Colors.green,
                          title: 'App Lock',
                          onTap: () {},
                        ),
                        const Divider(),
                        ProfileOption(
                          icon: Icons.logout,
                          color: Colors.red,
                          title: 'Logout',
                          onTap: () async {
                            await authViewModel.signOut();
                            if (context.mounted) {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                                (route) => false,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
