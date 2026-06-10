import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/themed_surfaces.dart';

class ThemeSelectionScreen extends StatelessWidget {
  const ThemeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final colors = context.appColors;

    return Scaffold(
      appBar: AppBar(title: const Text('Theme Selection')),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: themeProvider.themes.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final theme = themeProvider.themes[index];
            final selected = theme.id == themeProvider.selectedThemeId;

            return AppGlassContainer(
              color: selected ? colors.elevated : null,
              child: ListTile(
                leading: _ThemeSwatch(colors: theme.colors),
                title: Text(theme.name),
                trailing: selected
                    ? Icon(Icons.check_circle, color: colors.primary)
                    : null,
                selected: selected,
                onTap: () =>
                    context.read<ThemeProvider>().selectTheme(theme.id),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ThemeSwatch extends StatelessWidget {
  final AppThemeColors colors;

  const _ThemeSwatch({required this.colors});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colors.progressTrack),
        ),
        child: Align(
          alignment: Alignment.bottomRight,
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: colors.primary,
              borderRadius: BorderRadius.circular(9),
            ),
          ),
        ),
      ),
    );
  }
}
