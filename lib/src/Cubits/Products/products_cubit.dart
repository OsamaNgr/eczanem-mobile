import 'package:dio/dio.dart';
import 'package:eczanem_mobile/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:eczanem_mobile/src/model/category.dart';
import 'package:eczanem_mobile/src/model/product.dart';
import 'package:eczanem_mobile/src/model/user.dart';
import 'package:eczanem_mobile/src/services/api.dart';
part 'products_state.dart';

class SearchConstraints {
  const SearchConstraints._();
  static const String name = 'name';
  static const String scientificName = 'scientificName';
  static const String description = 'description';
  static const String brand = 'brand';
}

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit() : super(ProductsInitial());
  String searchBarContent = "";
  Category choosenCategory = Category(id: 0, name: "All". tr);
  String searchByConstraints = SearchConstraints.name;

  Future<void> search() async {
    logger.i(
        "Product Cubit Search :  \nChooosen category name :  ${choosenCategory.name} \nSearch bar content : $searchBarContent \nSearch By constraints : $searchByConstraints");
    try {
      emit(ProductsFetchLoading());

      String endpoint = '';
      bool isAllChoosen = (choosenCategory. name. toString() == "All" ||
          choosenCategory.name.toString() == "All".tr ||
          choosenCategory.name. toString() == "Tümü");

      if (searchBarContent == "" && isAllChoosen) {
        endpoint = 'medicines';
      } else if (searchBarContent == "" && !isAllChoosen) {
        endpoint = 'categories/${choosenCategory.id}';
      } else if (searchBarContent != "" && isAllChoosen) {
        endpoint = 'search/$searchBarContent/$searchByConstraints';
      } else if (searchBarContent != "" && !isAllChoosen) {
        endpoint =
            'search/${choosenCategory.id}/$searchBarContent/$searchByConstraints';
      }

      // Fetch Searched Products from API
      Map<String, dynamic> productsJsonData = await Api.request(
          url: endpoint,
          body: null,
          token: User.token,
          methodType: MethodType.get) as Map<String, dynamic>;
      List<Product> products = Product.fromListJson(productsJsonData);

      if (products.isEmpty) {
        emit(ProductsNotFound());
        logger.e("Product Cubit Search : \nProduct Not Found");
      } else {
        emit(ProductsFetchSuccess(products: products));
      }
    } on DioException catch (exception) {
      logger.e("Product Cubit Search : \nNetwork Failure");
      emit(ProductNetworkFailure(errorMessage: exception.message.toString()));
    } catch (e) {
      logger.e("Product Cubit Search : \nFetch Failure");
      emit(ProductsFetchFailure(errorMessage: e.toString()));
    }
  }

  Future<void> getFavourites() async {
    try {
      emit(ProductsFetchLoading());

      // Fetch Favourite Products from API
      Map<String, dynamic> favouriteJsonData = await Api.request(
          url: 'user/favorites',
          body: {},
          token: User.token,
          methodType: MethodType.get) as Map<String, dynamic>;
      List<Product> favouriteProducts = Product.fromListJson(favouriteJsonData);

      if (favouriteProducts.isEmpty) {
        emit(ProductsNotFound());
        logger.e("Product Cubit Favourite : \nProduct Not Found");
      } else {
        emit(ProductsFetchSuccess(products: favouriteProducts));
      }
    } on DioException catch (exception) {
      logger.e("Product Cubit Favourite : \nNetwork Failure ");
      emit(ProductNetworkFailure(errorMessage: exception.message.toString()));
    } catch (e) {
      logger.e("Product Cubit Favourite : \nFetch Failure ");
      emit(ProductsFetchFailure(errorMessage: e.toString()));
    }
  }
}