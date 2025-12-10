import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pharmacy_warehouse_store_mobile/core/assets/app_images.dart';
import 'package:pharmacy_warehouse_store_mobile/core/assets/app_vectors.dart';
import 'package:pharmacy_warehouse_store_mobile/core/constants/app_colors.dart';
import 'package:pharmacy_warehouse_store_mobile/src/Cubits/Auth/Logout/logout_cubit.dart';
import 'package:pharmacy_warehouse_store_mobile/src/Cubits/User/user_cubit.dart';
import 'package:pharmacy_warehouse_store_mobile/src/Cubits/Theme/theme_cubit.dart';
import 'package:pharmacy_warehouse_store_mobile/src/model/user.dart';
import 'package:pharmacy_warehouse_store_mobile/src/view/helpers/select_lang_dialog.dart';
import 'package:pharmacy_warehouse_store_mobile/src/view/helpers/show_loading_dialog.dart';
import 'package:pharmacy_warehouse_store_mobile/src/view/helpers/show_snack_bar.dart';
import 'package:pharmacy_warehouse_store_mobile/src/view/screens/auth/login_screen.dart';
import 'package:pharmacy_warehouse_store_mobile/src/view/screens/auth/register_screen.dart';
import 'package:pharmacy_warehouse_store_mobile/src/view/screens/drawer/statistics_screen.dart';
import 'package:pharmacy_warehouse_store_mobile/src/view/screens/navigation%20bar/home_screen.dart';
import 'package:pharmacy_warehouse_store_mobile/src/view/widgets/custome_icon_button.dart';
import 'package:pharmacy_warehouse_store_mobile/src/view/widgets/show_image.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  bool _isGuestMode() {
    // Check if user is not authenticated (null token or default test token)
    return User.token == null ||
           User.token == "5BBzrJ2GCfeBB3RIHYBL2mEO3epUXQ3NfRVGoyX1hnHvV5RzhUAwErrkzUl5";
  }

  @override
  Widget build(BuildContext context) {
    // Only fetch user if authenticated
    if (! _isGuestMode()) {
      BlocProvider.of<UserCubit>(context).getUser();
    }

    return Scaffold(
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
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.startWallpaper),
              fit:  BoxFit.cover,
            ),
          ),
          height: double.infinity,
          width: double.infinity,
          child: SafeArea(
            child: Stack(
              children: [
                const _AppBar(),
                // Show Guest Profile or Authenticated Profile
                _isGuestMode()
                    ? const _GuestProfileView()
                    : BlocConsumer<UserCubit, UserState>(
                        listener: (context, state) {
                          if (state is UserFetchFailure) {
                            showSnackBar(
                                state.errorMessage, SnackBarMessageType.error);
                          } else if (state is UserNetworkFailure) {
                            showSnackBar(
                                state.errorMessage, SnackBarMessageType.error);
                          }
                        },
                        builder: (context, state) {
                          if (state is UserFetchSuccess) {
                            User user = state.user;
                            return _ProfileSuccessView(
                              user: user,
                            );
                          } else if (state is UserFetchLoading) {
                            return const Center(
                              child:  CircularProgressIndicator(
                                color: AppColors.primaryColor,
                              ),
                            );
                          } else if (state is UserFetchFailure) {
                            return const Center(
                              child: ShowImage(
                                imagePath: AppImages.error,
                                height: 500,
                                width: 500,
                              ),
                            );
                          } else if (state is UserNetworkFailure) {
                            return const Center(
                              child: ShowImage(
                                imagePath: AppImages.error404,
                                height: 500,
                                width: 500,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Guest Profile View
class _GuestProfileView extends StatelessWidget {
  const _GuestProfileView();

  @override
  Widget build(BuildContext context) {
    var theme = context.theme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Guest Avatar
          const CircleAvatar(
            backgroundColor: Colors.lightBlueAccent,
            radius: 100,
            child: Icon(
              Icons.person_outline,
              size: 150,
              color: Colors.white,
            ),
          ),
          const SizedBox(height:  30),
          // Guest Message
          Text(
            "guestMode".tr,
            style: theme.textTheme.headlineLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "signInToAccessProfile".tr,
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 50),
          // Sign In Button
          SizedBox(
            width: 300,
            height: 55,
            child: ElevatedButton(
              onPressed: () {
                Get.to(() => LoginScreen());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                "signIn".tr,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Sign Up Button
          SizedBox(
            width:  300,
            height: 55,
            child: OutlinedButton(
              onPressed: () {
                Get.to(() => RegisterScreen());
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors. white, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                "signUp".tr,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight. bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          // Language Option
          _ProfileOptionsListTile(
            title: "language".tr,
            icon: Icons.language,
            onTap: () {
              showSelectLangDialog();
            },
          ),
          const SizedBox(height: 20),
          // Dark Mode Toggle
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              final isDark = state is ThemeChanged ? state.isDark : false;
              return _ProfileOptionsListTile(
                title: isDark ? "lightMode".tr : "darkMode". tr,
                icon: isDark ? Icons.light_mode : Icons.dark_mode,
                onTap: () {
                  BlocProvider.of<ThemeCubit>(context).toggleTheme();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProfileSuccessView extends StatelessWidget {
  const _ProfileSuccessView({required this.user});
  final User user;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _UserDetails(
          user: user,
        ),
        const SizedBox(
          height: 80,
        ),
        _ProfileOptionsListTile(
          title:  "statistics".tr,
          icon: Icons.assessment,
          onTap: () {
            Get.to(() => const StatisticsScreen());
          },
        ),
        const SizedBox(
          height: 20,
        ),
        _ProfileOptionsListTile(
          title: "language".tr,
          icon: Icons.language,
          onTap: () {
            showSelectLangDialog();
          },
        ),
        const SizedBox(
          height: 20,
        ),
        BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            final isDark = state is ThemeChanged ? state.isDark : false;
            return _ProfileOptionsListTile(
              title: isDark ? "lightMode".tr : "darkMode".tr,
              icon: isDark ? Icons.light_mode :  Icons.dark_mode,
              onTap: () {
                BlocProvider.of<ThemeCubit>(context).toggleTheme();
              },
            );
          },
        ),
        const SizedBox(
          height: 20,
        ),
        _ProfileOptionsListTile(
          title: "logout".tr,
          icon: Icons.logout,
          onTap: () {
            BlocProvider.of<LogoutCubit>(context).logout();
          },
        ),
      ],
    );
  }
}

class _UserDetails extends StatelessWidget {
  const _UserDetails({required this.user});
  final User user;
  @override
  Widget build(BuildContext context) {
    var theme = context.theme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CircleAvatar(
          backgroundColor: Colors.lightBlueAccent,
          radius: 100,
          child: Icon(
            Icons.account_circle,
            size: 200,
            color: Colors.white,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          user.name ?? 'N/A',
          style: theme.textTheme.headlineLarge,
        ),
        const SizedBox(
          height:  20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.storefront,
              size: 50,
              color: Colors.lightBlueAccent,
            ),
            const SizedBox(
              width:  20,
            ),
            Text(
              user.pharmacyName ?? 'N/A',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              width: 20,
            ),
            const Icon(
              Icons.storefront,
              size: 50,
              color: Colors.lightBlueAccent,
            ),
          ],
        ),
      ],
    );
  }
}

class _ProfileOptionsListTile extends StatelessWidget {
  const _ProfileOptionsListTile(
      {required this.title, required this.icon, required this. onTap});

  final IconData icon;
  final String title;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    var theme = context.theme;
    return SizedBox(
      width: 350,
      child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              icon,
              size: 40,
              color: Colors.white,
            ),
          ),
          title: SizedBox(
            child: Text(
              title,
              style: theme.textTheme.headlineLarge,
            ),
          ),
          subtitle: const SizedBox. shrink(),
          onTap: onTap),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomIconButton(
            onPressed: () {
              Get. off(() => const HomeScreen());
            },
            icon: SvgPicture.asset(
              AppVector.backArrowIcon,
              fit: BoxFit.none,
              matchTextDirection: true,
              // ignore: deprecated_member_use
              color: Colors.white,
            ),
            backgroundColor: Colors.lightBlueAccent,
          ),
        ],
      ),
    );
  }
}