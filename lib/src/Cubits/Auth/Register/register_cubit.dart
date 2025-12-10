import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:pharmacy_warehouse_store_mobile/src/model/user.dart' as app_user;
import 'package:pharmacy_warehouse_store_mobile/src/services/api.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  Future<void> registerWithEmail({
    required String email,
    required String userName,
    String? phoneNumber,
    required String password,
  }) async {
    try {
      emit(RegisterLoading());

      Map<String, dynamic> body = {
        'email': email,
        'name':  userName,
        'password': password,
      };

      if (phoneNumber != null && phoneNumber. isNotEmpty) {
        body['phone'] = phoneNumber;
      }

      dynamic registerData = await Api. request(
        url: 'register',
        body: body,
        headers: {
          'FCMToken': app_user.User.fCMToken ?? "",
        },
        token: app_user.User. token,
        methodType: MethodType.post,
      );

      dynamic token = registerData['token'];
      app_user. User.token = token;

      emit(RegisterSuccess());
    } on DioException catch (exception) {
      String errorMessage = exception.response?.data['message'] ??  
                           exception.message ??  
                           'Registration failed';
      emit(RegisterFailure(errorMessage: errorMessage));
    } catch (e) {
      emit(RegisterFailure(errorMessage: 'An unexpected error occurred'));
    }
  }
}