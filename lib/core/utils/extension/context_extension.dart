import 'package:flutter/material.dart';
import 'package:porfolio_task_calendar_app/core/app/app_colors.dart';
import 'package:porfolio_task_calendar_app/core/app/app_constants.dart';
import 'package:porfolio_task_calendar_app/core/app/app_numbers.dart';
import 'package:porfolio_task_calendar_app/core/l10n/app_localizations.dart';
import 'package:toastification/toastification.dart';

final GlobalKey<NavigatorState> appKey = GlobalKey<NavigatorState>();

extension ContextExtension on BuildContext {
  AppLocalizations get loc {
    return AppLocalizations.of(this) ?? _LocalizationFallback();
  }

  AppColors get color => AppColors.of(this);

  void snackbar(String message, {PopupType type = PopupType.info}) {
    if (!mounted) return;
    FocusScope.of(this).unfocus();
    toastification.show(
      context: this,
      type: type == PopupType.error
          ? ToastificationType.error
          : type == PopupType.info
          ? ToastificationType.info
          : ToastificationType.success,
      style: ToastificationStyle.flat,
      title: (Text("App: ")),
      description: Text(message),
      alignment: Alignment.bottomCenter,
      pauseOnHover: true,
      autoCloseDuration: const Duration(seconds: 4),
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      borderRadius: BorderRadius.circular(AppNumbers.radius),
      boxShadow: highModeShadow,
      showProgressBar: true,
      closeButton: const ToastCloseButton(showType: CloseButtonShowType.none),
      closeOnClick: false,
      dragToClose: true,
    );
  }

  Future<bool> dialogYesNo(String title, String subTitle, IconData icon) async {
    final res = await showDialog<bool>(
      context: this,
      builder: (ctx) => AlertDialog(
        backgroundColor: ctx.color.bg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppNumbers.radius)),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            const SizedBox(width: AppNumbers.space),
            Text(
              title,
              style: TextStyle(
                color: ctx.color.secondaryText,
                fontWeight: FontWeight.bold,
                fontSize: AppNumbers.getH3(ctx),
              ),
            ),
          ],
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppNumbers.padding),
              child: Text(
                subTitle,
                style: TextStyle(color: ctx.color.primaryText, fontSize: AppNumbers.body(ctx)),
              ),
            ),
            const SizedBox(height: AppNumbers.space),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: Text(
                    ctx.loc.no,
                    style: TextStyle(fontSize: AppNumbers.body(ctx), color: ctx.color.disabledText),
                  ),
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                ),

                TextButton(
                  child: Text(
                    ctx.loc.yes,
                    style: TextStyle(fontSize: AppNumbers.body(ctx), color: ctx.color.primaryAccent),
                  ),
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
    return res ?? false;
  }

  Future<bool> dialogCustom(
    String title,
    Widget child,
    String positiveText,
    String negativeText, {
    IconData? icon,
    String subTitle = '',
  }) async {
    final res = await showDialog<bool>(
      context: this,
      builder: (ctx) => AlertDialog(
        backgroundColor: ctx.color.bg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppNumbers.radius)),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[Icon(icon), const SizedBox(width: AppNumbers.space)],
            Text(
              title,
              style: TextStyle(
                color: ctx.color.secondaryText,
                fontWeight: FontWeight.bold,
                fontSize: AppNumbers.getH3(ctx),
              ),
            ),
          ],
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (subTitle.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppNumbers.padding),
                child: Text(
                  subTitle,
                  style: TextStyle(color: ctx.color.primaryText, fontSize: AppNumbers.body(ctx)),
                ),
              ),
              const SizedBox(height: AppNumbers.space),
            ],
            SizedBox(child: child),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: Text(
                    negativeText,
                    style: TextStyle(fontSize: AppNumbers.body(ctx), color: ctx.color.disabledText),
                  ),
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                ),
                TextButton(
                  child: Text(
                    positiveText,
                    style: TextStyle(fontSize: AppNumbers.body(ctx), color: ctx.color.primaryAccent),
                  ),
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
    return res ?? false;
  }

  /// Safely pops the current route, even from inside dialogs or bottom sheets.
  Future<bool> pop({bool? result, bool tryRootIfNotPopped = true}) async {
    // Ensure the context is valid
    if (this is! Element || !(this as Element).mounted) return false;

    // 1) Try the nearest Navigator (this covers normal sheets/dialogs/pages)
    final nearest = Navigator.maybeOf(this);
    if (nearest != null) {
      final popped = await nearest.maybePop<bool>(result);
      if (popped) return true;
    }

    if (tryRootIfNotPopped) {
      final root = Navigator.maybeOf(this, rootNavigator: true);
      if (root != null) {
        final popped = await root.maybePop<bool>(result);
        if (popped) return true;
      }
    }

    return false;
  }

  /// Same as FarmBUtils.goToWithFlag: returns `bool` (default: to false on null).
  Future<bool> goToWithFlag(Widget page, {bool rootNavigator = false, bool defaultValue = false}) async {
    final result = await _push<bool>(page, rootNavigator: rootNavigator);
    return result ?? defaultValue;
  }

  /// Same as FarmBUtils.goTo (trigger and forget).
  Future<void> goTo(Widget page, {bool rootNavigator = false}) async {
    // ignore the Future intentionally
    await _push(page, rootNavigator: rootNavigator);
  }

  // interfaced internal helper
  Future<T?> _push<T>(Widget page, {bool rootNavigator = false}) {
    final nav = Navigator.of(this, rootNavigator: rootNavigator);
    return nav.push<T>(
      MaterialPageRoute<T>(
        builder: (_) => page,
        settings: RouteSettings(name: page.toString()),
      ),
    );
  }
}

class _LocalizationFallback implements AppLocalizations {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    String methodName = invocation.memberName.toString();
    methodName = methodName.toUpperCase();
    methodName = methodName.replaceAll("_", " ");
    return "~~$methodName~~";
  }
}
