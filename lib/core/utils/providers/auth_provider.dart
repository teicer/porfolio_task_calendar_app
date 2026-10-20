import 'package:porfolio_task_calendar_app/core/utils/http/api_response.dart';
import 'package:porfolio_task_calendar_app/core/utils/log/log.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/supabase_service.dart';

class AuthProvider {
  final _supabase = SupabaseService.client;

  User? get user => _supabase.auth.currentUser;

  Future<APIResponse> signInWithPassword(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(email: email, password: password);
      Log.e('SIGN IN SUCCESS: ${response.user?.email} and ${response.session}');
      return APIResponse(status: 200, json: '', code: 'success_login');
    } on AuthException catch (e) {
      Log.e('SIGN IN ERROR: $e');
      return APIResponse(
        status: int.tryParse(e.statusCode ?? '') ?? -1,
        json: '',
        code: e.code ?? 'something_went_wrong',
      );
    } catch (e) {
      Log.e('SIGN IN ERROR: $e');
      return APIResponse(status: -1, json: '', code: 'something_went_wrong');
    }
  }

  Future<APIResponse> signUpWithPasswordResponse(String email, String password) async {
    try {
      final response = await _supabase.auth.signUp(email: email, password: password);
      Log.e('SIGN UP SUCCESS: ${response.user?.email} and ${response.session}');
      return APIResponse(status: 200, json: '', code: 'success_signup');
    } on AuthException catch (e) {
      Log.e('SIGN UP ERROR: $e');
      return APIResponse(
        status: int.tryParse(e.statusCode ?? '') ?? -1,
        json: '',
        code: e.code ?? 'something_went_wrong',
      );
    } catch (e) {
      Log.e('SIGN UP ERROR: $e');
      return APIResponse(status: -1, json: '', code: 'something_went_wrong');
    }
  }

  Future<APIResponse> signOutResponse() async {
    try {
      await _supabase.auth.signOut();
      Log.e('SIGN OUT SUCCESS');
      return APIResponse(status: 200, json: '', code: 'success_signout');
    } catch (e) {
      Log.e('SIGN OUT ERROR: $e');
      return APIResponse(status: -1, json: '', code: 'something_went_wrong');
    }
  }
}
