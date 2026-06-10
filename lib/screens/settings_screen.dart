import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/themed_surfaces.dart';
import 'theme_selection_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final themeName = context.watch<ThemeProvider>().currentTheme.name;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            AppGlassContainer(
              child: ListTile(
                leading: Icon(Icons.palette_outlined, color: colors.primary),
                title: const Text('Theme'),
                subtitle: Text(
                  themeName,
                  style: TextStyle(color: colors.mutedText),
                ),
                trailing: Icon(Icons.chevron_right, color: colors.mutedText),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ThemeSelectionScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
