import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:porfolio_task_calendar_app/core/app/app_constants.dart';
import 'package:porfolio_task_calendar_app/core/ui/components/progress_dialog.dart';
import 'package:porfolio_task_calendar_app/core/ui/pages/auth/auth_page.dart';
import 'package:porfolio_task_calendar_app/core/utils/app_utils.dart';
import 'package:porfolio_task_calendar_app/core/utils/extension/context_extension.dart';
import 'package:porfolio_task_calendar_app/core/utils/http/api_caller.dart';
import 'package:porfolio_task_calendar_app/core/utils/log/log.dart';
import 'package:porfolio_task_calendar_app/core/utils/providers/auth_provider.dart';
import 'package:porfolio_task_calendar_app/core/utils/providers/singleton_data_provider.dart';
import 'package:porfolio_task_calendar_app/core/utils/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DebugPage extends StatefulWidget {
  const DebugPage({super.key});
  @override
  State<DebugPage> createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  final supabase = SupabaseService.client;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Supabase connected!\n\n'
              'User: ${supabase.auth.currentUser?.email}',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                final response = await supabase.auth.signUp(email: 'c.ioannou.94@gmail.com', password: 'Test123456!');

                print('USER: ${response.user}');
                print('SESSION: ${response.session}');
              },
              child: const Text('Sign Up'),
            ),
            ElevatedButton(
              onPressed: () async {
                final response = await AuthProvider().signInWithPassword('c.ioannou.94@gmail.com', 'Test123456!');
                if (response.isSuccessful() && context.mounted) {
                  context.snackbar(AppUtils.getTranslation(response.code), type: PopupType.success);
                } else {
                  if (context.mounted) {
                    context.snackbar(AppUtils.getTranslation(response.code), type: PopupType.error);
                  }
                }
              },
              child: const Text('Sign In'),
            ),
            // Sign Out button
            ElevatedButton(
              onPressed: () async {
                final response = await AuthProvider().signOutResponse();
                if (response.isSuccessful() && context.mounted) {
                  context.snackbar(AppUtils.getTranslation(response.code), type: PopupType.success);
                  await context.goTo(AuthPage());
                } else {
                  if (context.mounted) {
                    context.snackbar(AppUtils.getTranslation(response.code), type: PopupType.error);
                  }
                }
              },
              child: const Text('Sign Out'),
            ),
            //final response = await Supabase.instance.client.from('test_connection').select();
            ElevatedButton(
              onPressed: () async {
                final response = await Supabase.instance.client.from('test_connection').select();
                print('Response from test_connection table: $response');
              },
              child: const Text('Test Connection'),
            ),

            ElevatedButton(
              onPressed: () async {
                context.snackbar('This is a test snackbar message.');
                context.snackbar('This is a test snackbar message.', type: PopupType.error);
                context.snackbar('This is a test snackbar message.', type: PopupType.success);
              },
              child: const Text('pop snackbar'),
            ),

            ElevatedButton(
              onPressed: () async {
                ProgressDialog.show();
                final response = await ApiCaller.select('test_connection');
                if (response.isSuccessful()) {
                  ProgressDialog.dismiss();
                  final parsedJson = jsonDecode(response.json);
                  for (final item in parsedJson) {
                    Log.e('--- ${item['id']} -- created_at: ${item['created_at']}');
                  }
                } else {
                  if (context.mounted) {
                    context.snackbar(AppUtils.getTranslation(response.code), type: PopupType.error);
                  }
                }
              },
              child: const Text('Test Connection with ApiCaller'),
            ),
            ElevatedButton(
              onPressed: () async {
                for (final category in SingletonDataProvider().categories) {
                  Log.e('Category: ${category.id} - ${category.name}');
                }
              },
              child: const Text('categories'),
            ),

            ElevatedButton(
              onPressed: () async {
                for (final category in SingletonDataProvider().tasks) {
                  Log.e('Task: ${category.id} - ${category.title} - subTasks: ${category.subTasks}');
                }
              },
              child: const Text('tasks'),
            ),
          ],
        ),
      ),
    );
  }
}
