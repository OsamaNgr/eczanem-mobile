part of 'social_login_cubit.dart';

abstract class SocialLoginState {}

class SocialLoginInitial extends SocialLoginState {}

class SocialLoginLoading extends SocialLoginState {
  final String provider;
  SocialLoginLoading({required this.provider});
}

class SocialLoginSuccess extends SocialLoginState {}

class SocialLoginCancelled extends SocialLoginState {}

class SocialLoginFailure extends SocialLoginState {
  final String errorMessage;
  SocialLoginFailure({required this.errorMessage});
}