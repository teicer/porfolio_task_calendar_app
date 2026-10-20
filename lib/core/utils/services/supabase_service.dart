import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://qgdchefwbdhpeariukys.supabase.co',
      publishableKey: 'sb_publishable_CfubcghOkFZZDkOEhlofQA_T0B_ci7j',
    );
    final response = await Supabase.instance.client.from('test_connection').select();

    print('Response from test_connection table: $response');
  }

  static SupabaseClient get client => Supabase.instance.client;
}
