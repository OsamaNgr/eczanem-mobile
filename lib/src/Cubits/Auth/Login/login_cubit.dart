import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:pharmacy_warehouse_store_mobile/src/model/user.dart' as app_user;
import 'package:pharmacy_warehouse_store_mobile/src/services/api.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> signInWithCredentials({
    required String emailOrPhone,
    required String password,
  }) async {
    try {
      emit(LoginLoading());

      dynamic loginData = await Api.request(
        url: 'login',
        body: {
          'email_or_phone': emailOrPhone,
          'password': password,
        },
        headers: {
          'FCMToken': app_user.User.fCMToken ??  "",
        },
        token: app_user.User.token,
        methodType: MethodType.post,
      );

      dynamic token = loginData['token'];
      app_user.User.token = token;

      emit(LoginSuccess());
    } on DioException catch (exception) {
      String errorMessage = exception.response?.data['message'] ?? 
                           exception.message ?? 
                           'Login failed';
      emit(LoginFailure(errorMessage: errorMessage));
    } catch (e) {
      emit(LoginFailure(errorMessage: 'An unexpected error occurred'));
    }
  }
}