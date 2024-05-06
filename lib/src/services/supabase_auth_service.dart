import 'package:flasher_ui/src/models/user_flashr.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthService {
  final GoTrueClient _auth = Supabase.instance.client.auth;
  final SupabaseClient _supabaseClient = Supabase.instance.client;


  UserFlashr? _userFromSupabase(User? user){
    if (user == null) {
      return null;
    } else {
      return UserFlashr(
        userUuid: user.id,
        email: user.email,
        username: user.userMetadata?['username']
      );
    }

  }

  UserFlashr? get user {
    final user = _supabaseClient.auth.currentUser;
    return _userFromSupabase(user);
  }

  Future<UserFlashr?> signUpWithEmailAndPassword(
    {required String email, required String password, required String username}) async {
    final response = await _supabaseClient.auth.signUp(
      email: email,
      password: password,
      data: {
        username: username,
      },
    );
    return _userFromSupabase(response.user);
  }

  Future<UserFlashr?> currentUser() async {
    return _userFromSupabase(_supabaseClient.auth.currentUser);
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    await _supabaseClient.auth.resetPasswordForEmail(email);
  }

  Future<void> signInWithEmail(
      {required String email, required String password}) async {
    try {
      await _auth.signInWithPassword(email: email, password: password);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> signUpWithEmail(
      {required String email, required String password}) async {
    try {
      await _auth.signUp(email: email, password: password);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> anounymousSignIn() async {
    try {
      await _auth.signInWithPassword(
          email: 'omar@gmail.com', password: '123456');
    } catch (e) {
      throw e.toString();
    }
  }

/*  Future<void> signInWithGoogle() async {
    try {
      await _auth.signInWithOAuth(Provider.google);
    } catch (e) {
      throw e.toString();
    }
  }*/

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw e.toString();
    }
  }

}