import 'package:flutter/material.dart';
import 'package:my_schedule/src/core/design_system/app_buttons.dart';
import 'package:my_schedule/src/core/design_system/app_scaffold.dart';
import 'package:my_schedule/src/core/design_system/app_spacing.dart';
import 'package:my_schedule/src/core/design_system/app_typography.dart';

class AppExampleWidget extends StatelessWidget {
  const AppExampleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Design System Example',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Build new screens with design system tokens.',
            style: AppTypography.textTheme.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppPrimaryButton(label: 'Primary action', onPressed: () {}),
        ],
      ),
    );
  }
}
