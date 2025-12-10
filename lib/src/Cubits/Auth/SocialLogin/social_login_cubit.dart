import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

part 'social_login_state.dart';

class SocialLoginCubit extends Cubit<SocialLoginState> {
  SocialLoginCubit() : super(SocialLoginInitial());

  final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle() async {
    try {
      emit(SocialLoginLoading(provider:  'Google'));

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        emit(SocialLoginCancelled());
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final firebase_auth.UserCredential userCredential = 
          await _firebaseAuth.signInWithCredential(credential);

      print("✅ Google Sign In Success:  ${userCredential.user?.email}");
      
      emit(SocialLoginSuccess());
    } catch (e) {
      print("❌ Google Sign In Error: $e");
      emit(SocialLoginFailure(errorMessage: "Failed to sign in with Google"));
    }
  }

  Future<void> signInWithApple() async {
    try {
      emit(SocialLoginLoading(provider: 'Apple'));

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = firebase_auth. OAuthProvider("apple.com").credential(
        idToken: credential.identityToken,
        accessToken:  credential.authorizationCode,
      );

      final firebase_auth.UserCredential userCredential = 
          await _firebaseAuth.signInWithCredential(oauthCredential);

      print("✅ Apple Sign In Success: ${userCredential.user?. email}");
      
      emit(SocialLoginSuccess());
    } catch (e) {
      print("❌ Apple Sign In Error: $e");
      emit(SocialLoginFailure(errorMessage: "Failed to sign in with Apple"));
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}