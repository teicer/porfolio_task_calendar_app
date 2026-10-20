import 'dart:convert';

import 'package:porfolio_task_calendar_app/core/utils/log/log.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/supabase_service.dart';
import 'api_response.dart';

class ApiCaller {
  static final SupabaseClient _supabase = SupabaseService.client;

  // SELECT
  static Future<APIResponse> select(String table, {bool withUser = false, Map<String, dynamic>? filters}) async {
    APIResponse response = APIResponse(status: -1, json: '', code: 'something_went_wrong');
    try {
      var query = _supabase.from(table).select();

      if (withUser) {
        final user = _supabase.auth.currentUser;

        if (user == null) {
          return APIResponse(status: 401, json: '', code: 'user_not_authenticated');
        }

        query = query.eq('user_id', user.id);
      }

      if (filters != null) {
        for (final entry in filters.entries) {
          query = query.eq(entry.key, entry.value);
        }
      }

      final data = await query;

      response = APIResponse(status: 200, json: jsonEncode(data), code: 'success');
      Log.e('_SELECT: ${response.toString()}');
      return response;
    } on PostgrestException catch (e) {
      response = APIResponse(status: 400, json: '', code: e.code ?? 'unknown_error');
      Log.e('_SELECT ERROR: ${response.toString()}');
      return response;
    } catch (e) {
      Log.e('_SELECT ERROR: ${response.toString()}');
      return response;
    }
  }

  // INSERT
  static Future<APIResponse> insert(String table, Map<String, dynamic> body) async {
    APIResponse response = APIResponse(status: -1, json: '', code: 'something_went_wrong');
    try {
      final data = await _supabase.from(table).insert(body).select();

      response = APIResponse(status: 201, json: jsonEncode(data), code: 'insert_success');
      Log.e('_INSERT: ${response.toString()}');
      return response;
    } on PostgrestException catch (e) {
      response = APIResponse(status: 400, json: '', code: e.code ?? 'unknown_error');
      Log.e('_INSERT ERROR: ${response.toString()}');
      return response;
    } catch (e) {
      Log.e('_INSERT ERROR: ${response.toString()}');
      return response;
    }
  }

  // UPDATE
  static Future<APIResponse> update(
    String table,
    Map<String, dynamic> body, {
    required Map<String, dynamic> filters,
  }) async {
    APIResponse response = APIResponse(status: -1, json: '', code: 'something_went_wrong');
    try {
      var query = _supabase.from(table).update(body);

      for (final entry in filters.entries) {
        query = query.eq(entry.key, entry.value);
      }
      final data = await query.select();
      response = APIResponse(status: 200, json: jsonEncode(data), code: 'update_success');
      Log.e('_UPDATE: ${response.toString()}');
      return response;
    } on PostgrestException catch (e) {
      response = APIResponse(status: 400, json: '', code: e.code ?? 'unknown_error');
      Log.e('_UPDATE ERROR: ${response.toString()}');
      return response;
    } catch (e) {
      Log.e('_UPDATE ERROR: ${response.toString()}');
      return response;
    }
  }

  // DELETE
  static Future<APIResponse> delete(String table, {required Map<String, dynamic> filters}) async {
    APIResponse response = APIResponse(status: -1, json: '', code: 'something_went_wrong');
    try {
      var query = _supabase.from(table).delete();

      for (final entry in filters.entries) {
        query = query.eq(entry.key, entry.value);
      }

      final data = await query.select();

      response = APIResponse(status: 200, json: jsonEncode(data), code: 'delete_success');
      Log.e('_DELETE: ${response.toString()}');
      return response;
    } on PostgrestException catch (e) {
      response = APIResponse(status: 400, json: '', code: e.code ?? 'unknown_error');
      Log.e('_DELETE ERROR: ${response.toString()}');
      return response;
    } catch (e) {
      Log.e('_DELETE ERROR: ${response.toString()}');
      return response;
    }
  }
}
