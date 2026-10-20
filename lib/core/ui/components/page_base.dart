import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:porfolio_task_calendar_app/core/app/app_numbers.dart';
import 'package:porfolio_task_calendar_app/core/utils/extension/context_extension.dart';

enum PageType { home, normal, init, auth }

class PageBase extends StatefulWidget {
  final PageType type;
  final String title;
  final Widget child;
  final String? subTitle;
  final Widget? leftSideWidget;
  final bool allowClose;
  const PageBase._({
    required this.type,
    required this.title,
    required this.child,
    super.key,
    this.subTitle,
    this.leftSideWidget,
    this.allowClose = true,
  });

  const PageBase.home({
    required String title,
    required Widget child,
    Key? key,
    String? subTitle,
    Widget? leftSideWidget,
    bool allowClose = true,
  }) : this._(
         key: key,
         type: PageType.home,
         title: title,
         child: child,
         subTitle: subTitle,
         leftSideWidget: leftSideWidget,
         allowClose: allowClose,
       );

  const PageBase.normal({
    required String title,
    required Widget child,
    Key? key,
    String? subTitle,
    Widget? leftSideWidget,
    bool allowClose = true,
  }) : this._(
         key: key,
         type: PageType.normal,
         title: title,
         child: child,
         subTitle: subTitle,
         leftSideWidget: leftSideWidget,
         allowClose: allowClose,
       );
  const PageBase.init({
    required String title,
    required Widget child,
    Key? key,
    String? subTitle,
    Widget? leftSideWidget,
    bool allowClose = true,
  }) : this._(
         key: key,
         type: PageType.init,
         title: title,
         child: child,
         subTitle: subTitle,
         leftSideWidget: leftSideWidget,
         allowClose: allowClose,
       );

  const PageBase.auth({
    required String title,
    required Widget child,
    Key? key,
    String? subTitle,
    Widget? leftSideWidget,
    bool allowClose = true,
  }) : this._(
         key: key,
         type: PageType.auth,
         title: title,
         child: child,
         subTitle: subTitle,
         leftSideWidget: leftSideWidget,
         allowClose: allowClose,
       );

  @override
  State<PageBase> createState() => _PageBaseState();
}

class _PageBaseState extends State<PageBase> with RouteAware {
  static SystemUiOverlayStyle _styleFor(BuildContext context, PageType t) {
    return SystemUiOverlayStyle(
      statusBarColor: context.color.transparent,
      systemNavigationBarColor: context.color.transparent,

      systemNavigationBarDividerColor: context.color.transparent,
    );
  }

  void _applyOverlay() {
    SystemChrome.setSystemUIOverlayStyle(_styleFor(context, widget.type));
  }

  final List<RouteObserver<PageRoute>> _subscribedObservers = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      final observers = Navigator.of(context).widget.observers.whereType<RouteObserver<PageRoute>>().toList();

      for (final observer in observers) {
        if (!_subscribedObservers.contains(observer)) {
          observer.subscribe(this, route);
          _subscribedObservers.add(observer);
        }
      }
    }
    _applyOverlay();
  }

  @override
  void dispose() {
    for (final observer in _subscribedObservers) {
      observer.unsubscribe(this);
    }
    _subscribedObservers.clear();
    super.dispose();
  }

  @override
  void didPush() => _applyOverlay();
  @override
  void didPopNext() => _applyOverlay(); // when a pushed page is popped

  @override
  Widget build(BuildContext context) {
    final Widget forRet = Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: context.color.bg,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppNumbers.padding),
          child: Column(
            children: [
              _buildTopBar(),
              const SizedBox(height: AppNumbers.padding),
              Expanded(child: widget.child),
              const SizedBox(height: AppNumbers.padding),
            ],
          ),
        ),
      ),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _styleFor(context, widget.type),
      child: widget.allowClose ? forRet : PopScope(canPop: false, child: forRet),
    );
  }

  Widget _buildTopBar() {
    if (widget.type == PageType.home) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${widget.title},',
                  style: TextStyle(fontSize: AppNumbers.getH2(context), color: context.color.primaryText),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  context.loc.we_have_work_to_do,
                  style: TextStyle(fontSize: AppNumbers.body(context), color: context.color.secondaryText),
                ),
              ],
            ),
          ),
          if (widget.leftSideWidget != null) widget.leftSideWidget!,
        ],
      );
    }
    if (widget.type == PageType.normal) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () async {
              await context.pop();
            },
            child: Icon(Icons.arrow_back, color: context.color.primaryText),
          ),
          const SizedBox(width: AppNumbers.space),
          Expanded(
            child: Text(
              widget.title,
              style: TextStyle(fontSize: AppNumbers.getH2(context), color: context.color.primaryText),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (widget.leftSideWidget != null) widget.leftSideWidget!,
        ],
      );
    }
    if (widget.type == PageType.auth) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [if (widget.leftSideWidget != null) widget.leftSideWidget!],
      );
    }

    return const SizedBox.shrink(); // return an empty widget for other page types
  }
}
