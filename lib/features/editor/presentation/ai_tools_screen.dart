import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AIToolsScreen extends ConsumerWidget {
  const AIToolsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Tools')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildToolCard(
            context,
            title: 'Auto Enhance',
            subtitle: 'Automatically adjust colors and contrast',
            icon: Icons.auto_fix_high,
            onTap: () {
              // Logic to pick image and enhance
            },
          ),
          const SizedBox(height: 16),
          _buildToolCard(
            context,
            title: 'AI Remaster',
            subtitle: 'Super-resolution and noise removal',
            icon: Icons.high_quality,
            onTap: () {
              // Logic to pick image and remaster
            },
          ),
          const SizedBox(height: 16),
          _buildToolCard(
            context,
            title: 'Object Removal',
            subtitle: 'Remove unwanted objects from photos',
            icon: Icons.layers_clear,
            onTap: () {
              // Logic for inpainting
            },
          ),
        ],
      ),
    );
  }

  Widget _buildToolCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading:
            Icon(icon, size: 40, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
