import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:eczanem_mobile/core/constants/app_colors.dart';
import 'package:eczanem_mobile/src/Cubits/Auth/Register/register_cubit.dart';
import 'package:eczanem_mobile/src/Cubits/Auth/SocialLogin/social_login_cubit.dart';
import 'package:eczanem_mobile/src/view/helpers/show_loading_dialog.dart';
import 'package:eczanem_mobile/src/view/helpers/show_snack_bar.dart';
import 'package:eczanem_mobile/src/view/screens/auth/login_screen.dart';
import 'package:eczanem_mobile/src/view/screens/navigation_bar/home_screen.dart';
import 'dart:io' show Platform;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? email, userName, phoneNumber, password, confirmPassword;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  final formKey = GlobalKey<FormState>();

  // Email validator
  String? emailValidator(String? value) {
    if (value == null || value. isEmpty) {
      return "fieldIsRequired".tr;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return "enterValidEmail".tr;
    }
    return null;
  }

  // Username validator
  String? userNameValidator(String? value) {
    if (value == null || value. isEmpty) {
      return "usernameRequired".tr;
    }
    if (value.length < 3) {
      return "usernameTooShort".tr;
    }
    if (value. length > 20) {
      return "usernameTooLong".tr;
    }
    return null;
  }

  // Turkish Phone validator (optional)
  String? userNumberValidator(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    String cleanedValue = value.replaceAll(RegExp(r'[\s-]'), '');

    if (! cleanedValue.startsWith('05')) {
      return "phoneInvalidFormat".tr;
    }

    if (cleanedValue.length != 11) {
      return "phoneInvalidLength".tr;
    }

    if (int.tryParse(cleanedValue) == null) {
      return "enterValidPhoneNumber".tr;
    }

    return null;
  }

  // Password validator
  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "passwordRequired".tr;
    }
    if (value.length < 8) {
      return "passwordTooShort".tr;
    }
    return null;
  }

  // Confirm Password validator
  String?  confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "passwordRequired".tr;
    }
    if (value. length < 8) {
      return "passwordTooShort". tr;
    }
    if (password != confirmPassword) {
      return "passwordsDoNotMatch".tr;
    }
    return null;
  }

  void registerUser() {
    if (formKey.currentState!.validate()) {
      BlocProvider.of<RegisterCubit>(context).registerWithEmail(
        email: email! ,
        userName: userName!,
        phoneNumber: phoneNumber,
        password: password!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners:  [
        BlocListener<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterLoading) {
              showLoadingDialog();
            } else if (state is RegisterSuccess) {
              Get.until((route) => !Get.isDialogOpen! );
              showSnackBar("registerSuccess".tr, SnackBarMessageType.success);
              Get. off(() => const HomeScreen());
            } else if (state is RegisterFailure) {
              Get.until((route) => !Get.isDialogOpen! );
              showSnackBar(state.errorMessage, SnackBarMessageType.error);
            }
          },
        ),
        BlocListener<SocialLoginCubit, SocialLoginState>(
          listener: (context, state) {
            if (state is SocialLoginLoading) {
              showLoadingDialog();
            } else if (state is SocialLoginSuccess) {
              Get.until((route) => !Get.isDialogOpen!);
              showSnackBar("registerSuccess".tr, SnackBarMessageType.success);
              Get.off(() => const HomeScreen());
            } else if (state is SocialLoginFailure) {
              Get.until((route) => !Get.isDialogOpen! );
              showSnackBar(state.errorMessage, SnackBarMessageType.error);
            } else if (state is SocialLoginCancelled) {
              Get.until((route) => !Get.isDialogOpen!);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors. primaryColor,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Eczanem",
                      style:  TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
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

              // White Card
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

                          // Email Field
                          TextFormField(
                            onChanged: (value) {
                              email = value;
                              setState(() {});
                            },
                            validator: emailValidator,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(fontSize: 16.sp, color: Colors.black87),
                            decoration: _buildInputDecoration("email".tr),
                          ),

                          SizedBox(height:  16.h),

                          // Username Field
                          TextFormField(
                            onChanged: (value) {
                              userName = value;
                              setState(() {});
                            },
                            validator: userNameValidator,
                            keyboardType: TextInputType. name,
                            style: TextStyle(fontSize: 16.sp, color: Colors.black87),
                            decoration: _buildInputDecoration("userName".tr),
                          ),

                          SizedBox(height:  16.h),

                          // Phone Field
                          TextFormField(
                            onChanged: (value) {
                              phoneNumber = value;
                              setState(() {});
                            },
                            validator: userNumberValidator,
                            keyboardType: TextInputType. phone,
                            style: TextStyle(fontSize: 16.sp, color: Colors.black87),
                            decoration: _buildInputDecoration("phoneNumberOptional".tr),
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
                            style: TextStyle(fontSize: 16.sp, color: Colors.black87),
                            decoration: _buildInputDecoration(
                              "password".tr,
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    obscurePassword = !obscurePassword;
                                  });
                                },
                                child:  Icon(
                                  obscurePassword
                                      ? Icons. visibility_off_outlined
                                      : Icons. visibility_outlined,
                                  color: Colors.grey. shade600,
                                  size: 22.sp,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 16.h),

                          // Confirm Password Field
                          TextFormField(
                            onChanged: (value) {
                              confirmPassword = value;
                              setState(() {});
                            },
                            validator: confirmPasswordValidator,
                            obscureText: obscureConfirmPassword,
                            style:  TextStyle(fontSize: 16.sp, color: Colors.black87),
                            decoration: _buildInputDecoration(
                              "confirmPassword".tr,
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    obscureConfirmPassword = !obscureConfirmPassword;
                                  });
                                },
                                child: Icon(
                                  obscureConfirmPassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Colors.grey.shade600,
                                  size: 22.sp,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 24.h),

                          // Sign Up Button
                          ElevatedButton(
                            onPressed:  registerUser,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              "signUp".tr,
                              style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          SizedBox(height: 24.h),

                          // Divider
                          Row(
                            children: [
                              Expanded(
                                child: Divider(color: Colors.grey.shade300, thickness: 1),
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
                                child: Divider(color: Colors.grey.shade300, thickness: 1),
                              ),
                            ],
                          ),

                          SizedBox(height: 24.h),

                          // Social Buttons
                          _SocialButton(
                            icon:  'assets/icons/google.svg',
                            label: "signInWithGoogle".tr,
                            onTap: () {
                              BlocProvider.of<SocialLoginCubit>(context)
                                  .signInWithGoogle();
                            },
                          ),

                          SizedBox(height: 12.h),

                          if (Platform.isIOS)
                            _SocialButton(
                              icon: 'assets/icons/apple.svg',
                              label: "signInWithApple".tr,
                              onTap: () {
                                BlocProvider.of<SocialLoginCubit>(context)
                                    .signInWithApple();
                              },
                            ),

                          SizedBox(height: 32.h),

                          // Login Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment. center,
                            children: [
                              Text(
                                "alreadyHaveAnAccount".tr,
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 15.sp,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Get.off(() => const LoginScreen()),
                                child: Text(
                                  "signIn".tr,
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

  InputDecoration _buildInputDecoration(String hint, {Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16.sp),
      filled: true,
      fillColor:  Colors.grey.shade100,
      contentPadding: EdgeInsets. symmetric(horizontal: 20.w, vertical: 18.h),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide:  BorderSide(color: AppColors.primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: Colors.red. shade300, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius:  BorderRadius.circular(12.r),
        borderSide: BorderSide(color: Colors.red, width: 2),
      ),
      errorStyle: TextStyle(fontSize: 13.sp, color: Colors.red. shade700, height: 1.2),
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
          SvgPicture.asset(
            icon,
            width: 24.w,
            height: 24.h,
          ),
          SizedBox(width: 12.w),
          Text(
            label,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}