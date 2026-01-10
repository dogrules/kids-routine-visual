import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/localization/app_localizations.dart';
import '../../data/defaults.dart';
import '../state/app_state_notifier.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final state = ref.watch(appStateProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.text('settings')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            strings.text('settings'),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          SegmentedButton<String>(
            segments: [
              ButtonSegment(
                value: 'child1',
                label: Text(strings.text('child1')),
              ),
              ButtonSegment(
                value: 'child2',
                label: Text(strings.text('child2')),
              ),
            ],
            selected: {state.activeProfileId},
            onSelectionChanged: (values) {
              ref
                  .read(appStateProvider.notifier)
                  .setActiveProfile(values.first);
            },
          ),
          const SizedBox(height: 24),
          SwitchListTile(
            title: Text(strings.text('showHelperText')),
            value: state.activeProfile.showHelperText,
            onChanged: (value) =>
                ref.read(appStateProvider.notifier).toggleHelperText(value),
          ),
          SwitchListTile(
            title: Text(strings.text('haptics')),
            value: state.activeProfile.hapticsEnabled,
            onChanged: (value) =>
                ref.read(appStateProvider.notifier).toggleHaptics(value),
          ),
          const SizedBox(height: 16),
          ListTile(
            title: Text(strings.text('editRoutines')),
            subtitle: Text(strings.text('morning')),
            trailing: const Icon(Icons.edit),
            onTap: () => context.go('/editor/$morningRoutineId'),
          ),
          ListTile(
            title: Text(strings.text('editRoutines')),
            subtitle: Text(strings.text('evening')),
            trailing: const Icon(Icons.edit),
            onTap: () => context.go('/editor/$eveningRoutineId'),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {
              ref.read(appStateProvider.notifier).resetDefaults();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Defaults restored')),
              );
            },
            icon: const Icon(Icons.restore),
            label: const Text('Restore defaults'),
          ),
        ],
      ),
    );
  }
}
