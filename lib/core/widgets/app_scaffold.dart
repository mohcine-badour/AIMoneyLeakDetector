import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.body,
    this.title,
    this.actions,
    this.floatingActionButton,
    this.leading,
    this.showAppBar,
    this.padding,
    super.key,
  });

  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? leading;
  final bool? showAppBar;
  final EdgeInsetsGeometry? padding;

  bool get _showAppBar => showAppBar ?? title != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !_showAppBar
          ? null
          : AppBar(
              title: title == null ? null : Text(title!),
              leading: leading,
              actions: actions,
            ),
      floatingActionButton: floatingActionButton,
      body: SafeArea(
        child: padding == null ? body : Padding(padding: padding!, child: body),
      ),
    );
  }
}
