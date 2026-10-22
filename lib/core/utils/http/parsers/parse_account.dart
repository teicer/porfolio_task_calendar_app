import 'dart:convert';

import 'package:porfolio_task_calendar_app/core/models/user_model.dart';
import 'package:porfolio_task_calendar_app/core/utils/http/json_base.dart';

class ParseAccount {
  Future<UserModel> getAccount(String jsonString, {required String userId}) async {
    final parsedJson = jsonDecode(jsonString);
    for (final u in parsedJson) {
      final UserModel user = UserModel();
      final JsonBase jsonBase = JsonBase(u);
      if (jsonBase.getStr('user_id') == userId) {
        user.userId = jsonBase.getStr('user_id');
        user.name = jsonBase.getStr('name');
        user.lastName = jsonBase.getStr('last_name');
        user.phone = jsonBase.getStr('phone');
        user.profileImg = jsonBase.getStr('profile_img');
        user.createdAt = jsonBase.getStr('created_at');
        user.updatedAt = jsonBase.getStr('updated_at');
        return user;
      }
    }
    return UserModel();
  }
}
