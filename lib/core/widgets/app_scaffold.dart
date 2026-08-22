import 'package:flutter/material.dart';

import 'app_tab_bar.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.body,
    this.title,
    this.actions,
    this.floatingActionButton,
    this.leading,
    this.showAppBar,
    this.padding,
    this.bottomBanner,
    this.showTabs = false,
    super.key,
  });

  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? leading;
  final bool? showAppBar;
  final EdgeInsetsGeometry? padding;
  final Widget? bottomBanner;
  final bool showTabs;

  bool get _showAppBar => showAppBar ?? title != null;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    Widget? bottom;
    if (bottomBanner != null || showTabs) {
      bottom = Column(
        mainAxisSize: MainAxisSize.min,
        children: [?bottomBanner, if (showTabs) const AppTabBar()],
      );
    }

    return Scaffold(
      appBar: !_showAppBar
          ? null
          : AppBar(
              title: title == null
                  ? null
                  : Text(title!, style: textTheme.titleLarge),
              leading: leading,
              actions: actions,
              centerTitle: false,
            ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottom,
      body: SafeArea(
        bottom: !showTabs,
        child: padding == null ? body : Padding(padding: padding!, child: body),
      ),
    );
  }
}
