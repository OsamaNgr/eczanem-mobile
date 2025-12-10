import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:eczanem_mobile/src/Cubits/AI/ai_assistant_cubit.dart';
import 'package:eczanem_mobile/src/Cubits/Auth/Login/login_cubit.dart';
import 'package:eczanem_mobile/src/Cubits/Auth/Logout/logout_cubit.dart';
import 'package:eczanem_mobile/src/Cubits/Auth/Register/register_cubit.dart';
import 'package:eczanem_mobile/src/Cubits/Auth/SocialLogin/social_login_cubit.dart';
import 'package:eczanem_mobile/src/Cubits/BottomNavBar/bottom_nav_bar_cubit.dart';
import 'package:eczanem_mobile/src/Cubits/Cart/cart_cubit.dart';
import 'package:eczanem_mobile/src/Cubits/Category/category_cubit.dart';
import 'package:eczanem_mobile/src/Cubits/Favourite/favourite_cubit.dart';
import 'package:eczanem_mobile/src/Cubits/Home/home_cubit.dart';
import 'package:eczanem_mobile/src/Cubits/Orders/orders_cubit.dart';
import 'package:eczanem_mobile/src/Cubits/Products/products_cubit.dart';
import 'package:eczanem_mobile/src/Cubits/Report/report_cubit.dart';
import 'package:eczanem_mobile/src/Cubits/Statistics/statistics_cubit.dart';
import 'package:eczanem_mobile/src/Cubits/Theme/theme_cubit.dart';
import 'package:eczanem_mobile/src/Cubits/User/user_cubit.dart';
import 'package:eczanem_mobile/src/locale/locale.dart';
import 'package:eczanem_mobile/src/view/screens/navigation_bar/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  try {
    await dotenv.load(fileName: ". env");
  } catch (e) {
    logger.w("No .env file found, continuing without it");
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create:  (context) => ProductsCubit()),
            BlocProvider(create: (context) => BottomNavBarCubit()),
            BlocProvider(create: (context) => FavouriteCubit()),
            BlocProvider(create: (context) => CartCubit()),
            BlocProvider(create: (context) => CategoryCubit()),
            BlocProvider(create: (context) => HomeCubit()),
            BlocProvider(create: (context) => LoginCubit()),
            BlocProvider(create: (context) => RegisterCubit()),
            BlocProvider(create: (context) => LogoutCubit()),
            BlocProvider(create: (context) => OrdersCubit()),
            BlocProvider(create: (context) => UserCubit()),
            BlocProvider(create: (context) => StatisticsCubit()),
            BlocProvider(create: (context) => ReportCubit()),
            BlocProvider(create: (context) => AIAssistantCubit()),
            BlocProvider(create: (context) => ThemeCubit().. loadTheme()),
            BlocProvider(create: (context) => SocialLoginCubit()),
          ],
          child:  BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              final isDark = state is ThemeChanged ? state.isDark :  false;
              final theme = isDark ? _darkTheme : _lightTheme;
              
              return GetMaterialApp(
                title: 'Eczanem',
                debugShowCheckedModeBanner: false,
                theme:  theme,
                translations: LocaleController(),
                locale: const Locale('en'),
                fallbackLocale: const Locale('en'),
                home: child,
              );
            },
          ),
        );
      },
      child: const HomeScreen(),
    );
  }
}

// Light Theme - Turkish Pharmacy Red & White
final ThemeData _lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.red,
  primaryColor: const Color(0xFFDC143C), // Turkish pharmacy red
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFDC143C), // Red app bar
    foregroundColor: Colors.white,
    elevation: 2,
  ),
  colorScheme: const ColorScheme. light(
    primary: Color(0xFFDC143C),
    secondary: Color(0xFFE31837),
    surface: Colors.white,
    error: Colors.red,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFDC143C),
  ),
);

// Dark Theme - Turkish Pharmacy Dark Mode
final ThemeData _darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.red,
  primaryColor: const Color(0xFFDC143C),
  scaffoldBackgroundColor:  const Color(0xFF1A1A1A),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF2C2C2C),
    foregroundColor: Colors.white,
    elevation: 2,
  ),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFFDC143C),
    secondary: Color(0xFFE31837),
    surface: Color(0xFF2C2C2C),
    error: Colors.red,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFDC143C),
  ),
);