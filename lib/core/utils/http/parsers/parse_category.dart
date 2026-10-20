import 'dart:convert';

import 'package:porfolio_task_calendar_app/core/utils/http/json_base.dart';
import 'package:porfolio_task_calendar_app/core/models/category_model.dart';

class ParseCategory {
  Future<List<CategoryModel>> getCategories(String jsonString) async {
    final parsedJson = jsonDecode(jsonString);
    List<CategoryModel> categories = [];
    if (parsedJson == null || parsedJson.isEmpty) {
      return categories;
    }
    for (final c in parsedJson) {
      final CategoryModel category = CategoryModel();
      final JsonBase jsonBase = JsonBase(c);

      category.id = jsonBase.getStr('id');
      category.name = jsonBase.getStr('name');
      category.nameAlias = jsonBase.getStr('name_alias');
      categories.add(category);
    }
    return categories;
  }
}
