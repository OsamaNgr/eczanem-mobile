import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:eczanem_mobile/core/assets/app_images.dart';
import 'package:eczanem_mobile/core/constants/app_colors.dart';
import 'package:eczanem_mobile/src/Cubits/Auth/Logout/logout_cubit.dart';
import 'package:eczanem_mobile/src/Cubits/User/user_cubit.dart';
import 'package:eczanem_mobile/src/Cubits/Theme/theme_cubit.dart';
import 'package:eczanem_mobile/src/model/user.dart';
import 'package:eczanem_mobile/src/view/helpers/select_lang_dialog.dart';
import 'package:eczanem_mobile/src/view/helpers/show_loading_dialog.dart';
import 'package:eczanem_mobile/src/view/helpers/show_snack_bar.dart';
import 'package:eczanem_mobile/src/view/screens/auth/login_screen.dart';
import 'package:eczanem_mobile/src/view/screens/auth/register_screen.dart';
import 'package:eczanem_mobile/src/view/screens/drawer/statistics_screen.dart';
import 'package:eczanem_mobile/src/view/widgets/show_image.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  bool _isGuestMode() {
    return User.token == null ||
           User.token == "5BBzrJ2GCfeBB3RIHYBL2mEO3epUXQ3NfRVGoyX1hnHvV5RzhUAwErrkzUl5";
  }

  @override
  Widget build(BuildContext context) {
    if (! _isGuestMode()) {
      BlocProvider.of<UserCubit>(context).getUser();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 0, // Hide app bar completely
      ),
      body: BlocListener<LogoutCubit, LogoutState>(
        listener: (context, state) {
          if (state is LogoutLoading) {
            showLoadingDialog();
          } else if (state is LogoutSuccess) {
            Get.until((route) => !Get.isDialogOpen! );
            showSnackBar("logedOutSuccess".tr, SnackBarMessageType.success);
            Get.off(() => LoginScreen());
          } else if (state is LogoutFailure) {
            Get.until((route) => !Get.isDialogOpen!);
            showSnackBar(state.errorMessage, SnackBarMessageType.error);
          }
        },
        child:  _isGuestMode()
            ? const _GuestProfileView()
            : BlocConsumer<UserCubit, UserState>(
                listener: (context, state) {
                  if (state is UserFetchFailure) {
                    showSnackBar(state.errorMessage, SnackBarMessageType. error);
                  } else if (state is UserNetworkFailure) {
                    showSnackBar(state.errorMessage, SnackBarMessageType.error);
                  }
                },
                builder: (context, state) {
                  if (state is UserFetchSuccess) {
                    return _ProfileSuccessView(user: state.user);
                  } else if (state is UserFetchLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors. primaryColor,
                      ),
                    );
                  } else if (state is UserFetchFailure) {
                    return const Center(
                      child: ShowImage(
                        imagePath: AppImages.error,
                        height: 300,
                        width: 300,
                      ),
                    );
                  } else if (state is UserNetworkFailure) {
                    return const Center(
                      child: ShowImage(
                        imagePath: AppImages.error404,
                        height: 300,
                        width: 300,
                      ),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  );
                },
              ),
      ),
    );
  }
}

// Guest Profile View - Login Form Style
class _GuestProfileView extends StatefulWidget {
  const _GuestProfileView();

  @override
  State<_GuestProfileView> createState() => _GuestProfileViewState();
}

class _GuestProfileViewState extends State<_GuestProfileView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:  Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),

            // Email TextField
            TextField(
              controller:  _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: "Email",
                hintStyle: TextStyle(
                  color: Colors.grey. shade400,
                  fontSize: 16,
                ),
                filled: true,
                fillColor:  Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:  BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius:  BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primaryColor,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),

            const SizedBox(height:  16),

            // Password TextField
            TextField(
              controller: _passwordController,
              obscureText:  _obscurePassword,
              decoration: InputDecoration(
                hintText: "Password",
                hintStyle: TextStyle(
                  color: Colors.grey. shade400,
                  fontSize:  16,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius:  BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:  BorderSide(color: Colors. grey.shade200),
                ),
                focusedBorder:  OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primaryColor,
                    width: 2,
                  ),
                ),
                contentPadding:  const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons. visibility_off : Icons.visibility,
                    color: Colors.grey.shade600,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Sign In Button
            SizedBox(
              height: 50,
              child:  ElevatedButton(
                onPressed: () {
                  // TODO: Implement login logic
                  Get.to(() => LoginScreen());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Sign In",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Divider with "or"
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "or",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ),
                const Expanded(child: Divider()),
              ],
            ),

            const SizedBox(height:  24),

            // Social Login Buttons
            _SocialLoginButton(
              icon:  Icons.g_mobiledata,
              label: "Continue with Google",
              onTap: () {
                // TODO: Implement Google Sign In
                showSnackBar(
                    "Google Sign In - Coming Soon", SnackBarMessageType.info);
              },
            ),

            const SizedBox(height:  12),

            _SocialLoginButton(
              icon: Icons.apple,
              label: "Continue with Apple",
              onTap:  () {
                // TODO:  Implement Apple Sign In
                showSnackBar(
                    "Apple Sign In - Coming Soon", SnackBarMessageType.info);
              },
            ),

            const SizedBox(height: 12),

            _SocialLoginButton(
              icon: Icons.facebook,
              label: "Continue with Facebook",
              iconColor: const Color(0xFF1877F2), // Facebook blue
              onTap: () {
                // TODO: Implement Facebook Sign In
                showSnackBar("Facebook Sign In - Coming Soon",
                    SnackBarMessageType.info);
              },
            ),

            const SizedBox(height: 32),

            // Sign Up Text Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account?  ",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => RegisterScreen());
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight. bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Social Login Button Widget
class _SocialLoginButton extends StatelessWidget {
  const _SocialLoginButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey.shade300, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment. center,
          children: [
            Icon(
              icon,
              color: iconColor ?? AppColors.textColor,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Authenticated Profile View (After Login)
class _ProfileSuccessView extends StatelessWidget {
  const _ProfileSuccessView({required this.user});
  final User user;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:  Column(
        children: [
          // Top Section with User Info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32),
            decoration: BoxDecoration(
              color: AppColors.primaryColor. withOpacity(0.05),
            ),
            child: Column(
              children: [
                // Avatar
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primaryColor. withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 40,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user.name ??  'N/A',
                  style:  const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.local_pharmacy,
                      size: 16,
                      color: AppColors.primaryColor,
                    ),
                    const SizedBox(width:  6),
                    Text(
                      user.pharmacyName ?? 'N/A',
                      style: const TextStyle(
                        fontSize:  14,
                        color:  AppColors.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // User Profile Options List
          _ProfileOptionItem(
            icon: Icons.person,
            title: "User Information",
            onTap: () {
              showSnackBar(
                  "User Information - Coming Soon", SnackBarMessageType.info);
            },
          ),
          const Divider(height: 1),

          _ProfileOptionItem(
            icon: Icons.location_on,
            title: "Addresses",
            onTap: () {
              showSnackBar("Addresses - Coming Soon", SnackBarMessageType.info);
            },
          ),
          const Divider(height: 1),

          _ProfileOptionItem(
            icon: Icons.credit_card,
            title: "Saved Cards",
            onTap: () {
              showSnackBar(
                  "Saved Cards - Coming Soon", SnackBarMessageType.info);
            },
          ),
          const Divider(height: 1),

          _ProfileOptionItem(
            icon: Icons.assessment,
            title: "Statistics",
            onTap: () {
              Get.to(() => const StatisticsScreen());
            },
          ),
          const Divider(height: 1),

          _ProfileOptionItem(
            icon: Icons.notifications,
            title: "Notifications",
            onTap: () {
              showSnackBar(
                  "Notifications - Coming Soon", SnackBarMessageType.info);
            },
          ),
          const Divider(height: 1),

          // Settings Section
          _ProfileOptionItem(
            icon: Icons.language,
            title: "Language",
            onTap: () {
              showSelectLangDialog();
            },
          ),
          const Divider(height: 1),

          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              final isDark = state is ThemeChanged ?  state.isDark : false;
              return _ProfileOptionItem(
                icon: isDark ? Icons.light_mode :  Icons.dark_mode,
                title: isDark ? "Light Mode" : "Dark Mode",
                onTap: () {
                  BlocProvider.of<ThemeCubit>(context).toggleTheme();
                },
              );
            },
          ),
          const Divider(height:  1),

          _ProfileOptionItem(
            icon:  Icons.logout,
            title: "Logout",
            iconColor: Colors.red,
            onTap: () {
              BlocProvider.of<LogoutCubit>(context).logout();
            },
          ),
          const Divider(height: 1),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// Profile Option Item Widget
class _ProfileOptionItem extends StatelessWidget {
  const _ProfileOptionItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child:  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              color:  iconColor ?? AppColors.primaryColor,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.secondaryTextColor,
            ),
          ],
        ),
      ),
    );
  }
}