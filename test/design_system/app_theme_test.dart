import 'package:flutter_test/flutter_test.dart';
import 'package:my_schedule/src/core/design_system/design_system.dart';

void main() {
  test('AppTheme.light uses design system tokens', () {
    final theme = AppTheme.light();

    expect(theme.colorScheme.primary, AppColors.primary);
    expect(theme.scaffoldBackgroundColor, AppColors.background);
    expect(
      theme.textTheme.bodyMedium?.fontSize,
      AppTypography.textTheme.bodyMedium?.fontSize,
    );
  });
}
