import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:eczanem_mobile/core/constants/app_colors.dart';
import 'package:eczanem_mobile/src/Cubits/BottomNavBar/bottom_nav_bar_cubit.dart';
import 'package:eczanem_mobile/src/view/screens/drawer/profile_screen.dart';
import 'package:eczanem_mobile/src/view/screens/navigation_bar/orders_screen.dart';
import 'package:eczanem_mobile/src/view/screens/navigation_bar/products_list_screen.dart';
import 'package:eczanem_mobile/src/view/screens/navigation_bar/search_screen.dart';
import 'package:eczanem_mobile/src/view/screens/navigation_bar/ai_assistant_screen.dart';
import 'package:eczanem_mobile/src/view/screens/navigation_bar/cart_orders_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super. key});

  static const List<Widget> screen = [
    ProductsListScreen(), // Index 0 - Home
    SearchScreen(),       // Index 1 - Search
    AIAssistantScreen(),  // Index 2 - AI Assistant
    OrdersScreen(),       // Index 3 - Orders
    ProfileScreen(),      // Index 4 - Profile
  ];

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
      builder: (context, state) {
        return Scaffold(
          appBar: const _HomeAppBar(),
          body: SizedBox. expand(
            child: HomeScreen
                .screen[BlocProvider.of<BottomNavBarCubit>(context).index],
          ),
          bottomNavigationBar: BottomNavyBar(
            backgroundColor: AppColors.primaryColor, // RED background
            selectedIndex: BlocProvider.of<BottomNavBarCubit>(context).index,
            containerHeight: 70,
            onItemSelected: (index) {
              BlocProvider.of<BottomNavBarCubit>(context)
                  .navigate(index:  index);
            },
            items: <BottomNavyBarItem>[
              BottomNavyBarItem(
                title: Text("home".tr),
                icon: const Icon(
                  Icons.home,
                  size: 32,
                ),
                activeColor: Colors.white, // WHITE when selected
                inactiveColor: const Color(0xFFFFB3B3), // Light pink when not selected
              ),
              BottomNavyBarItem(
                title: Text("search".tr),
                icon: const Icon(
                  Icons.search,
                  size: 32,
                ),
                activeColor: Colors. white,
                inactiveColor: const Color(0xFFFFB3B3),
              ),
              BottomNavyBarItem(
                title: Text("aiAssistant".tr),
                icon: const Icon(
                  Icons. chat_bubble_outline,
                  size: 32,
                ),
                activeColor: Colors.white,
                inactiveColor: const Color(0xFFFFB3B3),
              ),
              BottomNavyBarItem(
                title: Text("orders". tr),
                icon: const Icon(
                  Icons.receipt,
                  size: 32,
                ),
                activeColor:  Colors.white,
                inactiveColor: const Color(0xFFFFB3B3),
              ),
              BottomNavyBarItem(
                title:  Text("profile".tr),
                icon: const Icon(
                  Icons.person,
                  size: 32,
                ),
                activeColor: Colors.white,
                inactiveColor: const Color(0xFFFFB3B3),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _HomeAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primaryColor, // RED background
      title: const Text(
        'Eczanem',
        style: TextStyle(
          color: Colors. white, // WHITE text
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () async {
            Get.to(() => const CartOrdersScreen());
          },
          icon: const Icon(
            Icons. shopping_cart,
            size:  40,
            color: Colors.white, // WHITE cart icon
          ),
        ),
      ],
    );
  }
}