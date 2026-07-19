import '/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import '/components/my_button.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(5.0),
          child: MyButton(
            icon: Icon(HugeIcons.strokeRoundedArrowLeft01, size: 30),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: const Text('Settings'),
      ),
      body: Column(
        children: [_buildSwitchListTile(context), _buildListTile(context)],
      ),
    );
  }

  Widget _buildListTile(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ListTile(
        title: const Text('App Info'),
        trailing: Icon(
          HugeIcons.strokeRoundedInformationCircle,
          color: theme.colorScheme.inversePrimary,
        ),
        tileColor: theme.colorScheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onTap:
            () => showAboutDialog(
              context: context,
              applicationName: 'Notes App',
              applicationVersion: '1.0.0',
              applicationIcon: const Icon(
                HugeIcons.strokeRoundedInformationCircle,
              ),
              children: [
                const SizedBox(height: 10),
                const Text('This is a simple notes app built with Flutter.'),
              ],
            ),
      ),
    );
  }

  Widget _buildSwitchListTile(BuildContext context) {
    final theme = Theme.of(context);
    final scaffoldBackgroundColor = theme.scaffoldBackgroundColor;
    final inversePrimaryColor = theme.colorScheme.inversePrimary;

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SwitchListTile(
        title: const Text('Dark Mode'),
        value: context.watch<ThemeProvider>().isDarkMode,
        onChanged: (value) {
          context.read<ThemeProvider>().toggleTheme();
        },
        activeTrackColor: scaffoldBackgroundColor,
        inactiveTrackColor: scaffoldBackgroundColor,
        activeThumbColor: inversePrimaryColor,
        inactiveThumbColor: inversePrimaryColor,
        tileColor: theme.colorScheme.primary,
        trackOutlineColor: WidgetStatePropertyAll(scaffoldBackgroundColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
