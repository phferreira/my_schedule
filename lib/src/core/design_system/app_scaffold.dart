import 'package:flutter/material.dart';
import 'package:my_schedule/src/core/design_system/app_spacing.dart';
import 'package:my_schedule/src/core/design_system/app_typography.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
  });

  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: AppTypography.textTheme.titleLarge),
        actions: actions,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: body,
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
