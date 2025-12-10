import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:eczanem_mobile/core/constants/app_colors.dart';
import 'package:eczanem_mobile/src/Cubits/Products/products_cubit.dart';

void showSearchByDialog() {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 8,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black. withOpacity(0.2),
              blurRadius: 20.0,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor. withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.tune,
                    color: AppColors.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  "Search By",
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight:  FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Choose how to search for products",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey. shade600,
              ),
            ),
            const SizedBox(height: 24.0),
            
            // Search Options
            _buildSearchOption(SearchConstraints.name, "Product Name"),
            const SizedBox(height: 12.0),
            _buildSearchOption(SearchConstraints.scientificName, "Scientific Name"),
            const SizedBox(height: 12.0),
            _buildSearchOption(SearchConstraints.description, "Description"),
            const SizedBox(height: 12.0),
            _buildSearchOption(SearchConstraints.brand, "Brand"),
          ],
        ),
      ),
    ),
    barrierDismissible: true,
  );
}

Widget _buildSearchOption(String constraint, String label) {
  String currentConstraint =
      BlocProvider.of<ProductsCubit>(Get.context!).searchByConstraints;
  bool isSelected = currentConstraint == constraint;

  return InkWell(
    onTap: () {
      BlocProvider.of<ProductsCubit>(Get.context!).searchByConstraints = constraint;
      Get.back();
    },
    borderRadius: BorderRadius.circular(12),
    child: Container(
      padding: const EdgeInsets. symmetric(horizontal: 16, vertical:  12),
      decoration: BoxDecoration(
        color: isSelected 
            ? AppColors.primaryColor.withOpacity(0.1) 
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected 
              ? AppColors.primaryColor 
              : Colors.grey.shade200,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected 
                    ?  AppColors.primaryColor 
                    : Colors.grey.shade400,
                width: 2,
              ),
              color: Colors.white,
            ),
            child:  isSelected
                ? Center(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        shape:  BoxShape.circle,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected 
                  ? AppColors.primaryColor 
                  : AppColors.textColor,
            ),
          ),
        ],
      ),
    ),
  );
}