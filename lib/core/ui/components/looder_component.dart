import 'package:flutter/material.dart';
import 'package:porfolio_task_calendar_app/core/utils/extension/context_extension.dart';

class LoaderComponent extends StatelessWidget {
  const LoaderComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(color: context.color.primaryAccent);
  }
}
