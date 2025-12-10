import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_warehouse_store_mobile/core/constants/app_colors.dart';
import 'package:pharmacy_warehouse_store_mobile/src/view/screens/navigation bar/cart_screen.dart';

class CartOrdersScreen extends StatelessWidget {
  const CartOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryColor),
          onPressed: () => Get. back(),
        ),
        title: Text(
          "cart". tr,
          style: const TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: const CartScreen(),
    );
  }
}