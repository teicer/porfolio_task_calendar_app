import 'package:porfolio_task_calendar_app/core/utils/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserModel {
  factory UserModel() => _instance;
  UserModel._internal();
  static final UserModel _instance = UserModel._internal();
  static final SupabaseClient _supabase = SupabaseService.client;
  String userId = "";
  String name = "";
  String lastName = "";
  String email = _supabase.auth.currentUser?.email ?? "_error_@email.com";
  String phone = "";
  String profileImg = "";
  String createdAt = "";
  String updatedAt = "";

  Map<String, dynamic> toJson() {
    return {
      'user_id': _supabase.auth.currentUser?.id ?? "",
      'name': name,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'profile_img': profileImg,
      'created_at': createdAt.isEmpty ? DateTime.now().toIso8601String() : createdAt,
      'updated_at': updatedAt.isEmpty ? DateTime.now().toIso8601String() : updatedAt,
    };
  }
}
