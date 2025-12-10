import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:eczanem_mobile/core/assets/app_images.dart';
import 'package:eczanem_mobile/core/constants/app_colors.dart';
import 'package:eczanem_mobile/src/Cubits/Category/category_cubit.dart';
import 'package:eczanem_mobile/src/Cubits/Products/products_cubit.dart';
import 'package:eczanem_mobile/src/model/product.dart';
import 'package:eczanem_mobile/src/view/helpers/show_snack_bar.dart';
import 'package:eczanem_mobile/src/view/widgets/custome_text_field.dart';
import 'package:eczanem_mobile/src/view/widgets/product_list_tile.dart';
import 'package:eczanem_mobile/src/view/widgets/show_image.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super. key});
  
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CategoryCubit>(context).getCategories();
    BlocProvider.of<ProductsCubit>(context).search();
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CustomeTextField(
                obscureText: false,
                hintText: "searchFor".tr,
                onChanged: (value) {
                  BlocProvider.of<ProductsCubit>(context).searchBarContent = value;
                },
                onSubmit: (value) {
                  BlocProvider.of<ProductsCubit>(context).search();
                },
                validator: null,
                keyboardType: TextInputType. text,
                prefixIcon:  Icons.search,
                onTap: () {
                  BlocProvider.of<ProductsCubit>(context).search();
                },
                isSearchBar: true,
              ),
            ),
            
            // Categories Filter
            const SizedBox(height:  8),
            const _CategoriesCardsView(),
            
            // Divider
            Divider(height: 1, color: Colors.grey.shade200),
            
            // Products List
            const Expanded(child: _ProductCardsView()),
          ],
        ),
      ),
    );
  }
}

// Products List View
class _ProductCardsView extends StatelessWidget {
  const _ProductCardsView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductsCubit, ProductsState>(
      listener: (context, state) {
        if (state is ProductsFetchFailure) {
          showSnackBar(state.errorMessage, SnackBarMessageType. error);
        } else if (state is ProductNetworkFailure) {
          showSnackBar(state.errorMessage, SnackBarMessageType.error);
        }
      },
      builder:  (context, state) {
        if (state is ProductsFetchSuccess) {
          var products = state.products;
          return _ProductsSuccessView(products: products);
        } else if (state is ProductsFetchLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color:  AppColors.primaryColor,
            ),
          );
        } else if (state is ProductsNotFound) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ShowImage(
                  imagePath:  AppImages.noData,
                  height: 200,
                  width: 200,
                ),
                const SizedBox(height: 16),
                Text(
                  "noProductsFound".tr,
                  style: const TextStyle(
                    fontSize:  18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "tryDifferentSearch".tr,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        } else if (state is ProductsFetchFailure) {
          return const Center(
            child: ShowImage(
              imagePath: AppImages.error,
              height: 200,
              width: 200,
            ),
          );
        } else if (state is ProductNetworkFailure) {
          return const Center(
            child: ShowImage(
              imagePath: AppImages.error404,
              height: 200,
              width:  200,
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(
            color:  AppColors.primaryColor,
          ),
        );
      },
    );
  }
}

// Products Success View
class _ProductsSuccessView extends StatelessWidget {
  const _ProductsSuccessView({required this.products});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical:  8),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: ProductListTile(
            product: products[index],
          ),
        );
      },
    );
  }
}

// Categories Filter View
class _CategoriesCardsView extends StatefulWidget {
  const _CategoriesCardsView();

  @override
  State<_CategoriesCardsView> createState() => _CategoriesCardsViewState();
}

class _CategoriesCardsViewState extends State<_CategoriesCardsView> {
  int selectedIndex = 0;
  
  @override
  void initState() {
    selectedIndex = BlocProvider.of<ProductsCubit>(context).choosenCategory. id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = context.theme;
    return SizedBox(
      height: 50,
      child: BlocConsumer<CategoryCubit, CategoryState>(
        listener:  (context, state) {
          if (state is CategoryFetchFailure) {
            showSnackBar(state.errorMessage, SnackBarMessageType.error);
          } else if (state is CategoryNetworkFailure) {
            showSnackBar(state.errorMessage, SnackBarMessageType. error);
          }
        },
        builder: (context, state) {
          if (state is CategoryFetchSuccess) {
            var categories = state.categories;
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis. horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final isSelected = index == selectedIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                      BlocProvider.of<ProductsCubit>(context).choosenCategory =
                          categories[selectedIndex];
                      BlocProvider.of<ProductsCubit>(context).search();
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? AppColors.primaryColor 
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border. all(
                        color: isSelected 
                            ? AppColors.primaryColor 
                            : Colors. grey.shade300,
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        categories[index].name,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: isSelected 
                              ? Colors.white 
                              : AppColors.textColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is CategoryFetchFailure) {
            return const SizedBox. shrink();
          } else if (state is CategoryNetworkFailure) {
            return const SizedBox.shrink();
          }
          return const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
                strokeWidth: 2,
              ),
            ),
          );
        },
      ),
    );
  }
}