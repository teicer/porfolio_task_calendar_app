import 'dart:async';

import 'package:porfolio_task_calendar_app/core/app/app_icons.dart';
import 'package:porfolio_task_calendar_app/core/ui/components/button_component.dart';
import 'package:porfolio_task_calendar_app/core/utils/extension/context_extension.dart';
import 'package:material_ui/material_ui.dart';
import 'package:porfolio_task_calendar_app/core/app/app_numbers.dart';

class ProgressDialog {
  static final GlobalKey<_LoadingWidgetState> _key = GlobalKey();
  static PageRoute<void>? _route;
  static Completer<void>? _closing;

  static void show({int initialCount = -1, int duration = 15}) {
    if (_route != null) return;
    _closing = null; // reset
    _route = _BlockingProgressRoute(
      builder: (_) => _LoadingWidget(key: _key, initialCount: initialCount, duration: duration),
    );
    unawaited(appKey.currentState!.push(_route!));
  }

  static void dismiss() {
    _key.currentState?._startFadeOut();
  }

  static bool isShowing() => _route != null;

  static void _removeRouteNow() {
    final nav = appKey.currentState;
    final r = _route;
    if (nav != null && r != null) {
      nav.removeRoute(r);
    }
    _route = null;
    _closing?.complete(); // complete the waiter
    _closing = null;
  }

  static void refreshUpdate(int value, int max) {
    _key.currentState?.updateCount(value, max);
  }
}

class _LoadingWidget extends StatefulWidget {
  const _LoadingWidget({required this.initialCount, required this.duration, super.key});
  final int? initialCount;
  final int duration;

  @override
  State<_LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<_LoadingWidget> {
  static final Color _defBg = Colors.black.withValues(alpha: 0.5);
  static Timer? _dismissTimer;
  static Timer? _messageTimer;
  bool _showMessage = false;
  double _opacity = 0.0;
  int? _count;
  int? _maxCount;

  @override
  void initState() {
    super.initState();
    _opacity = 0.0;
    _count = widget.initialCount;
    _maxCount = widget.initialCount;

    if (_count == -1) {
      _messageTimer = Timer(Duration(seconds: (widget.duration - 5)), () {
        if (mounted) setState(() => _showMessage = true);
      });

      _dismissTimer = Timer(Duration(seconds: widget.duration), () {
        if (mounted) {
          setState(() => _opacity = 0.0);

          Future.delayed(const Duration(milliseconds: 400), () {
            if (!mounted) return;
            ProgressDialog.dismiss();
          });
        }
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  @override
  void dispose() {
    if (_count == -1) {
      _dismissTimer?.cancel();
      _messageTimer?.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 400),
      opacity: _opacity,
      curve: Curves.easeInOut,
      child: Material(
        color: _defBg,
        child: Stack(
          children: [
            const ModalBarrier(dismissible: false),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(color: context.color.overBg.withAlpha(170), shape: BoxShape.circle),
                    child: Padding(
                      padding: EdgeInsets.all(AppNumbers.paddingSmall),
                      child: CircularProgressIndicator(color: context.color.primaryAccent),
                    ),
                  ),
                  const SizedBox(height: AppNumbers.space),
                  if (_count != -1)
                    Padding(
                      padding: const EdgeInsets.all(AppNumbers.padding),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(AppNumbers.paddingSmall),
                          child: Column(
                            children: [
                              Text(
                                '$_count / $_maxCount',
                                style: Theme.of(context).textTheme.titleLarge,
                                textAlign: TextAlign.center,
                              ),
                              ButtonComponent(
                                title: 'context.loc.cancel',
                                onPressed: () {
                                  ProgressDialog.dismiss();
                                },
                                icon: AppIcons.close,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  if (_showMessage && _count == -1)
                    Padding(
                      padding: const EdgeInsets.all(AppNumbers.padding),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(AppNumbers.paddingSmall),
                          child: Text('context.loc.process_takes_longer', textAlign: TextAlign.center),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateCount(int value, int max) {
    if (!mounted) return;
    setState(() {
      _count = value;
      _maxCount = max;
    });
  }

  void _startFadeOut() {
    if (!mounted) return;
    // No opacity animation, just remove immediately
    ProgressDialog._removeRouteNow();
  }
}

class _BlockingProgressRoute extends PageRoute<void> {
  _BlockingProgressRoute({required this.builder});

  final WidgetBuilder builder;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withAlpha(138);

  @override
  String get barrierLabel => 'Progress';

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  // Don’t allow system/programmatic pops while shown
  @override
  Widget buildPage(BuildContext context, Animation<double> a, Animation<double> b) {
    return PopScope(
      canPop: false, // <- blocks back button + iOS swipe
      child: builder(context),
    );
  }

  @override
  bool get maintainState {
    return true;
  }
}
