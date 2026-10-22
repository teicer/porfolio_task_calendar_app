import 'package:porfolio_task_calendar_app/core/utils/http/parsers/parse_category.dart';
import 'package:porfolio_task_calendar_app/core/utils/http/parsers/parse_tasks.dart';
import 'package:porfolio_task_calendar_app/core/utils/http/parsers/parse_account.dart';

class JSONParser {
  static final ParseCategory parseCategory = ParseCategory();
  static final ParseTask parseTask = ParseTask();
  static final ParseAccount parseAccount = ParseAccount();
}
