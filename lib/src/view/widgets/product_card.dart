import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eczanem_mobile/core/constants/app_colors.dart';
import 'package:eczanem_mobile/src/model/product.dart';
import 'package:eczanem_mobile/src/view/screens/product_details_screen.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    var theme = context.theme;
    return GestureDetector(
      onTap: () {
        Get.off(() => ProductDetailsScreen(), arguments: product);
      },
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow:  [
            BoxShadow(
              color: Colors.black. withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  topLeft: Radius.circular(16),
                ),
                color: Colors.grey.shade100,
              ),
              child:  ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  topLeft: Radius.circular(16),
                ),
                child: Image.network(
                  product. image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.medical_services,
                      size:  60,
                      color: AppColors.primaryColor,
                    );
                  },
                ),
              ),
            ),
            
            // Product Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Product Name
                    AutoSizeText(
                      product.name,
                      style: theme.textTheme.bodyLarge! .copyWith(
                        color: AppColors.textColor,
                        fontWeight: FontWeight. bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                      minFontSize: 12,
                    ),
                    const SizedBox(height: 4),
                    
                    // Scientific Name
                    AutoSizeText(
                      product.scientificName,
                      style: theme.textTheme. bodySmall!.copyWith(
                        color: AppColors. secondaryTextColor,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                      minFontSize: 10,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Price Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: AutoSizeText(
                        "${product.price} ${"SP".tr}",
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        minFontSize: 10,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}