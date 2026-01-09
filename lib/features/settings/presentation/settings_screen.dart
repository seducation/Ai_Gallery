import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Theme Mode'),
            subtitle: Text(themeMode.toString().split('.').last),
            trailing: IconButton(
              icon: Icon(themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode),
              onPressed: () =>
                  ref.read(themeNotifierProvider.notifier).toggleTheme(),
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Privacy'),
            subtitle: const Text('All AI processing is done locally'),
            leading: const Icon(Icons.security),
            onTap: () {},
          ),
          ListTile(
            title: const Text('About'),
            subtitle: const Text('AI Gallery v0.1.0'),
            leading: const Icon(Icons.info_outline),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
