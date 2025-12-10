import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:eczanem_mobile/core/assets/app_images.dart';
import 'package:eczanem_mobile/core/constants/app_colors.dart';
import 'package:eczanem_mobile/src/Cubits/BottomNavBar/bottom_nav_bar_cubit.dart';
import 'package:eczanem_mobile/src/Cubits/Category/category_cubit.dart';
import 'package:eczanem_mobile/src/Cubits/Home/home_cubit.dart';
import 'package:eczanem_mobile/src/Cubits/Products/products_cubit.dart';
import 'package:eczanem_mobile/src/model/category.dart';
import 'package:eczanem_mobile/src/model/product.dart';
import 'package:eczanem_mobile/src/view/helpers/show_snack_bar.dart';
import 'package:eczanem_mobile/src/view/widgets/custome_text_field.dart';
import 'package:eczanem_mobile/src/view/widgets/product_card.dart';
import 'package:eczanem_mobile/src/view/widgets/show_image.dart';

class ProductsListScreen extends StatelessWidget {
  const ProductsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    BlocProvider.of<CategoryCubit>(context).getCategories();
    BlocProvider.of<HomeCubit>(context).getHomeProducts();
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light gray background
      body: SingleChildScrollView(
        child:  Padding(
          padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SearchBar(),
              const SizedBox(height:  20),
              
              // Categories Section (WITHOUT "See All")
              Text(
                "categories".tr,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 10),
              const _CategoriesCardsView(),
              const SizedBox(height: 20),
              
              // Most Popular Section
              Text(
                "mostPopular".tr,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors. textColor,
                ),
              ),
              const SizedBox(height: 10),
              const _ProductsCardsView(
                  homeProductsType: HomeProductsType.mostPopular),
              const SizedBox(height: 20),
              
              // Recently Added Section
              Text(
                "recentlyAdd". tr,
                style: theme. textTheme.titleLarge?. copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height:  10),
              const _ProductsCardsView(
                  homeProductsType: HomeProductsType.recentlyAdded),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return CustomeTextField(
      obscureText: false,
      hintText: "searchFor". tr,
      onChanged: (value) {
        BlocProvider.of<ProductsCubit>(context).searchBarContent = value;
      },
      onSubmit: (value) {
        BlocProvider.of<BottomNavBarCubit>(context).navigate(index: 1);
        BlocProvider.of<ProductsCubit>(context).search();
      },
      validator: null,
      keyboardType: TextInputType.text,
      prefixIcon: Icons.search,
      onTap: () {
        BlocProvider.of<BottomNavBarCubit>(context).navigate(index: 1);
        BlocProvider.of<ProductsCubit>(context).search();
      },
      isSearchBar: true,
    );
  }
}

class _ProductsCardsView extends StatelessWidget {
  const _ProductsCardsView({required this.homeProductsType});
  final String homeProductsType;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      width: double.infinity,
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is HomeProductsFetchFailure) {
            showSnackBar(state.errorMessage, SnackBarMessageType.error);
          } else if (state is HomeNetworkFailure) {
            showSnackBar(state.errorMessage, SnackBarMessageType.error);
          }
        },
        builder: (context, state) {
          if (state is HomeProductsFetchSucess) {
            List<Product> products = [];
            if (homeProductsType == HomeProductsType.mostPopular) {
              products = state.mostPopular;
            } else if (homeProductsType == HomeProductsType. recentlyAdded) {
              products = state.recentlyAdded;
            }
            return _ProductsCardsViewSuccess(products: products);
          } else if (state is HomeProductsFetchFailure) {
            return const ShowImage(
              imagePath: AppImages.error,
              height: 200,
              width: 200,
            );
          } else if (state is HomeNetworkFailure) {
            return const ShowImage(
              imagePath: AppImages.error404,
              height: 200,
              width: 200,
            );
          }
          return const Center(
            child: CircularProgressIndicator(
              color:  AppColors.primaryColor,
            ),
          );
        },
      ),
    );
  }
}

class _ProductsCardsViewSuccess extends StatelessWidget {
  const _ProductsCardsViewSuccess({
    required this. products,
  });

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets. only(right: 12.0),
          child: ProductCard(
            product: products[index],
          ),
        );
      },
    );
  }
}

class _CategoriesCardsView extends StatelessWidget {
  const _CategoriesCardsView();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: BlocConsumer<CategoryCubit, CategoryState>(
        listener: (context, state) {
          if (state is CategoryFetchFailure) {
            showSnackBar(state. errorMessage, SnackBarMessageType.error);
          } else if (state is CategoryNetworkFailure) {
            showSnackBar(state.errorMessage, SnackBarMessageType.error);
          }
        },
        builder: (context, state) {
          if (state is CategoryFetchSuccess) {
            return _CategoriesCardsViewSuccess(categories: state.categories);
          } else if (state is CategoryFetchFailure) {
            return const ShowImage(
              imagePath: AppImages.error,
              height: 200,
              width: 200,
            );
          } else if (state is CategoryNetworkFailure) {
            return const ShowImage(
              imagePath: AppImages.error404,
              height: 200,
              width: 200,
            );
          }
          return const Center(
            child: CircularProgressIndicator(
              color:  AppColors.primaryColor,
            ),
          );
        },
      ),
    );
  }
}

class _CategoriesCardsViewSuccess extends StatelessWidget {
  const _CategoriesCardsViewSuccess({required this. categories});
  final List<Category> categories;
  
  @override
  Widget build(BuildContext context) {
    var theme = context.theme;
    return ListView.builder(
      itemCount: categories.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap:  () {
            BlocProvider. of<BottomNavBarCubit>(context).navigate(index: 1);
            BlocProvider.of<ProductsCubit>(context).choosenCategory =
                categories[index];
            BlocProvider.of<ProductsCubit>(context).search();
          },
          child:  Container(
            width: 120,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: AppColors.primaryColor.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child:  Column(
              mainAxisAlignment:  MainAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors. primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.medical_services,
                    color: AppColors.primaryColor,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    categories[index].name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: AppColors.textColor,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}