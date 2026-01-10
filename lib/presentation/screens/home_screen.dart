import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/localization/app_localizations.dart';
import '../../data/defaults.dart';
import '../state/app_state_notifier.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final profile = ref.watch(appStateProvider).activeProfile;
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.text('appTitle')),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              profile.name,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _RoutineButton(
                    label: strings.text('morning'),
                    icon: Icons.wb_sunny,
                    color: Colors.orange,
                    onTap: () => context.go('/routine/$morningRoutineId'),
                  ),
                  const SizedBox(height: 24),
                  _RoutineButton(
                    label: strings.text('evening'),
                    icon: Icons.nights_stay,
                    color: Colors.indigo,
                    onTap: () => context.go('/routine/$eveningRoutineId'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoutineButton extends StatelessWidget {
  const _RoutineButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 120,
      child: ElevatedButton.icon(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          textStyle: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        icon: Icon(icon, size: 42),
        label: Text(label),
      ),
    );
  }
}
