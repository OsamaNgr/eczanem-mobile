import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eczanem_mobile/src/model/user.dart' as app_user;

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit() : super(LogoutInitial());

  Future<void> logout() async {
    try {
      emit(LogoutLoading());
      
      await FirebaseAuth.instance.signOut();
      
      app_user.User.clear();
      
      emit(LogoutSuccess());
    } catch (e) {
      emit(LogoutFailure(errorMessage:  'Failed to logout'));
    }
  }
}