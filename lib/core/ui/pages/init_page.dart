import 'package:flutter/widgets.dart';
import 'package:porfolio_task_calendar_app/core/app/app_constants.dart';
import 'package:porfolio_task_calendar_app/core/models/user_model.dart';
import 'package:porfolio_task_calendar_app/core/ui/components/page_base.dart';
import 'package:porfolio_task_calendar_app/core/ui/components/progress_dialog.dart';
import 'package:porfolio_task_calendar_app/core/ui/pages/auth/auth_page.dart';
// import 'package:porfolio_task_calendar_app/core/ui/pages/debug/debug_page.dart';
import 'package:porfolio_task_calendar_app/core/ui/pages/home/home_page.dart';
import 'package:porfolio_task_calendar_app/core/utils/app_utils.dart';
import 'package:porfolio_task_calendar_app/core/utils/extension/context_extension.dart';
import 'package:porfolio_task_calendar_app/core/utils/http/api_caller.dart';
import 'package:porfolio_task_calendar_app/core/utils/http/json_parser.dart';
import 'package:porfolio_task_calendar_app/core/utils/providers/singleton_data_provider.dart';
import 'package:porfolio_task_calendar_app/core/utils/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InitPage extends StatefulWidget {
  const InitPage({super.key});

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  static final SupabaseClient _supabase = SupabaseService.client;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ProgressDialog.show();
      await Future.delayed(Duration(milliseconds: 350));
      bool a = await _fetchCategories();
      bool b = await _fetchTasks();
      bool c = await _fetchAccount();
      ProgressDialog.dismiss();
      await _goTo(a && b && c);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageBase.init(
      title: 'Init Page',
      child: Center(child: Image.asset('lib/core/images/welcome.png')),
    );
  }

  Future<bool> _fetchCategories() async {
    final response = await ApiCaller.select(AppConstants.categories);
    if (response.isSuccessful()) {
      final data = await JSONParser.parseCategory.getCategories(response.json);
      SingletonDataProvider().categories = data;
      return true;
    } else {
      if (mounted) {
        context.snackbar(AppUtils.getTranslation(response.code), type: PopupType.error);
      }
    }
    return false;
  }

  Future<bool> _fetchTasks() async {
    final response = await ApiCaller.select(AppConstants.tasks, withUser: true);
    if (response.isSuccessful()) {
      final data = await JSONParser.parseTask.getAllTasks(response.json);
      SingletonDataProvider().tasks = data;
      AppUtils.recalculateTaskDays();
      AppUtils.recalculateTaskCounter();
      return true;
    } else {
      if (mounted) {
        context.snackbar(AppUtils.getTranslation(response.code), type: PopupType.error);
      }
    }
    return false;
  }

  Future<bool> _fetchAccount() async {
    final response = await ApiCaller.select(AppConstants.account, withUser: true);
    if (response.isSuccessful()) {
      final data = await JSONParser.parseAccount.getAccount(response.json, userId: _supabase.auth.currentUser!.id);
      if (data.userId.isEmpty) {
        final response = await ApiCaller.insert(AppConstants.account, UserModel().toJson());
        if (response.isSuccessful()) {
          UserModel().userId = _supabase.auth.currentUser!.id;
          return true;
        }
      }
      return true;
    } else {
      if (mounted) {
        context.snackbar(AppUtils.getTranslation(response.code), type: PopupType.error);
      }
    }
    return false;
  }

  Future<void> _goTo(bool fetched) async {
    if (fetched) {
      await context.goTo(HomePage());
    } else {
      await context.goTo(AuthPage());
    }
  }
}
