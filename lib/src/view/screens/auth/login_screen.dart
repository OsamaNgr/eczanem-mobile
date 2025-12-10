import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:eczanem_mobile/core/constants/app_colors.dart';
import 'package:eczanem_mobile/src/Cubits/Auth/Login/login_cubit.dart';
import 'package:eczanem_mobile/src/Cubits/Auth/SocialLogin/social_login_cubit.dart';
import 'package:eczanem_mobile/src/view/helpers/show_loading_dialog.dart';
import 'package:eczanem_mobile/src/view/helpers/show_snack_bar.dart';
import 'package:eczanem_mobile/src/view/screens/auth/register_screen.dart';
import 'package:eczanem_mobile/src/view/screens/navigation_bar/home_screen.dart';
import 'dart:io' show Platform;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? emailOrPhone, password;
  bool obscurePassword = true;
  final formKey = GlobalKey<FormState>();

  // Email or Phone validator
  String? emailOrPhoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "fieldIsRequired".tr;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (emailRegex.hasMatch(value)) {
      return null;
    }

    String cleanedValue = value.replaceAll(RegExp(r'[\s-]'), '');
    if (cleanedValue.startsWith('05') && cleanedValue.length == 11) {
      if (int.tryParse(cleanedValue) != null) {
        return null;
      }
    }

    return "enterValidEmailOrPhone".tr;
  }

  // Password validator
  String?  passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "passwordRequired".tr;
    }
    if (value.length < 8) {
      return "passwordTooShort".tr;
    }
    return null;
  }

  void signInUser() {
    if (formKey.currentState!.validate()) {
      BlocProvider.of<LoginCubit>(context)
          .signInWithCredentials(emailOrPhone:  emailOrPhone!, password: password!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners:  [
        BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginLoading) {
              showLoadingDialog();
            } else if (state is LoginSuccess) {
              Get.until((route) => !Get.isDialogOpen! );
              showSnackBar("signedInSuccess".tr, SnackBarMessageType.success);
              Get. off(() => const HomeScreen());
            } else if (state is LoginFailure) {
              Get.until((route) => !Get.isDialogOpen!);
              showSnackBar(state. errorMessage, SnackBarMessageType.error);
            }
          },
        ),
        BlocListener<SocialLoginCubit, SocialLoginState>(
          listener: (context, state) {
            if (state is SocialLoginLoading) {
              showLoadingDialog();
            } else if (state is SocialLoginSuccess) {
              Get.until((route) => !Get.isDialogOpen!);
              showSnackBar("signedInSuccess".tr, SnackBarMessageType. success);
              Get.off(() => const HomeScreen());
            } else if (state is SocialLoginFailure) {
              Get. until((route) => !Get.isDialogOpen!);
              showSnackBar(state.errorMessage, SnackBarMessageType.error);
            } else if (state is SocialLoginCancelled) {
              Get. until((route) => !Get.isDialogOpen!);
            }
          },
        ),
      ],
      child:  Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: SafeArea(
          child: Column(
            children: [
              // Header with logo and close button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Logo/Title
                    Text(
                      "Eczanem",
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    // Close button
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 28.sp,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              // White Card Container
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft:  Radius.circular(30.r),
                      topRight: Radius.circular(30.r),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(24.w),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 10.h),

                          // Email/Phone Field
                          TextFormField(
                            onChanged: (value) {
                              emailOrPhone = value;
                              setState(() {});
                            },
                            validator: emailOrPhoneValidator,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                              hintText: "userNumber".tr,
                              hintStyle: TextStyle(
                                color: Colors.grey. shade400,
                                fontSize: 16.sp,
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              contentPadding: EdgeInsets. symmetric(
                                horizontal: 20.w,
                                vertical: 18.h,
                              ),
                              border: OutlineInputBorder(
                                borderRadius:  BorderRadius.circular(12.r),
                                borderSide: BorderSide. none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:  BorderRadius.circular(12.r),
                                borderSide:  BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide(
                                  color: AppColors.primaryColor,
                                  width: 2,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius:  BorderRadius.circular(12.r),
                                borderSide:  BorderSide(
                                  color: Colors.red. shade300,
                                  width: 1,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide(
                                  color:  Colors.red,
                                  width: 2,
                                ),
                              ),
                              errorStyle: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.red. shade700,
                                height: 1.2,
                              ),
                            ),
                          ),

                          SizedBox(height: 16.h),

                          // Password Field
                          TextFormField(
                            onChanged: (value) {
                              password = value;
                              setState(() {});
                            },
                            validator: passwordValidator,
                            obscureText: obscurePassword,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors. black87,
                            ),
                            decoration: InputDecoration(
                              hintText: "password".tr,
                              hintStyle: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 16.sp,
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              contentPadding: EdgeInsets. symmetric(
                                horizontal: 20.w,
                                vertical: 18.h,
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    obscurePassword = !obscurePassword;
                                  });
                                },
                                child:  Icon(
                                  obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons. visibility_outlined,
                                  color: Colors.grey.shade600,
                                  size: 22.sp,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius. circular(12.r),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide(
                                  color: AppColors.primaryColor,
                                  width:  2,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide(
                                  color:  Colors.red.shade300,
                                  width: 1,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide(
                                  color:  Colors.red,
                                  width: 2,
                                ),
                              ),
                              errorStyle: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.red.shade700,
                                height: 1.2,
                              ),
                            ),
                          ),

                          // Forgot Password
                          Align(
                            alignment:  Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                showSnackBar("forgotPasswordComingSoon".tr,
                                    SnackBarMessageType.info);
                              },
                              child: Text(
                                "forgotPassword". tr,
                                style: TextStyle(
                                  color:  AppColors.secondaryColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 10.h),

                          // Sign In Button
                          ElevatedButton(
                            onPressed: signInUser,
                            style: ElevatedButton. styleFrom(
                              backgroundColor:  AppColors.primaryColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              "signIn".tr,
                              style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          SizedBox(height: 24.h),

                          // Divider with "Other Sign-In Options"
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Colors.grey.shade300,
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: Text(
                                  "orContinueWith".tr,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Colors.grey.shade300,
                                  thickness:  1,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 24.h),

                          // Social Login Buttons
                          _SocialButton(
                            icon: 'assets/icons/google.png',
                            label: "signInWithGoogle".tr,
                            onTap: () {
                              BlocProvider.of<SocialLoginCubit>(context)
                                  .signInWithGoogle();
                            },
                          ),

                          SizedBox(height: 12.h),

                          if (Platform.isIOS)
                            _SocialButton(
                              icon: 'assets/icons/apple.png',
                              label: "signInWithApple".tr,
                              onTap: () {
                                BlocProvider.of<SocialLoginCubit>(context)
                                    .signInWithApple();
                              },
                            ),

                          SizedBox(height: 32.h),

                          // Sign Up Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment. center,
                            children: [
                              Text(
                                "notAMember".tr,
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 15.sp,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Get.off(() => RegisterScreen()),
                                child: Text(
                                  "register".tr,
                                  style: TextStyle(
                                    color: AppColors.secondaryColor,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight. bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height:  20.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Social Button Widget
class _SocialButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this. onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        side: BorderSide(color: Colors.grey.shade300, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            icon,
            width: 24.w,
            height: 24.h,
          ),
          SizedBox(width: 12.w),
          Text(
            label,
            style: TextStyle(
              color: Colors. black87,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}