import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/icon_mapper.dart';
import '../../core/localization/app_localizations.dart';
import '../../data/models.dart';
import '../state/app_state_notifier.dart';
import '../widgets/reward_dialog.dart';
import '../widgets/timer_overlay.dart';

class RoutineScreen extends ConsumerStatefulWidget {
  const RoutineScreen({super.key, required this.routineId});

  final String routineId;

  @override
  ConsumerState<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends ConsumerState<RoutineScreen> {
  bool _rewardShown = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkReward();
  }

  void _checkReward() {
    final notifier = ref.read(appStateProvider.notifier);
    if (notifier.rewardAvailable(widget.routineId) && !_rewardShown) {
      _rewardShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (context) => RewardDialog(
            onDone: () {
              Navigator.of(context).pop();
              notifier.markRewarded(widget.routineId);
            },
          ),
        );
      });
    }
  }

  Future<void> _showTimer(RoutineTask task) async {
    await showDialog<void>(
      context: context,
      builder: (context) => TimerOverlay(
        initialSeconds: task.timerSeconds,
        onComplete: () {
          Navigator.of(context).pop();
          _showMarkDone(task);
        },
      ),
    );
  }

  Future<void> _showMarkDone(RoutineTask task) async {
    final strings = AppLocalizations.of(context);
    final shouldMark = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(strings.text('markDone')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(strings.text('no')),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(strings.text('yes')),
          ),
        ],
      ),
    );
    if (shouldMark == true) {
      ref
          .read(appStateProvider.notifier)
          .toggleTaskDone(widget.routineId, task.id, done: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final appState = ref.watch(appStateProvider);
    final routine = appState.routineFor(widget.routineId);
    if (routine == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Routine')),
        body: const Center(child: Text('Routine not found')),
      );
    }
    final progress = appState.activeProfile.progressFor(widget.routineId);
    final completed = progress.completedTaskIds.toSet();
    final showHelperText = appState.activeProfile.showHelperText;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(routine.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt),
            tooltip: strings.text('reset'),
            onPressed: () =>
                ref.read(appStateProvider.notifier).resetRoutine(routine.id),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text('${completed.length}/${routine.tasks.length}'),
            ),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: routine.tasks.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final task = routine.tasks[index];
          final isDone = completed.contains(task.id);
          return _RoutineTaskCard(
            task: task,
            showHelperText: showHelperText,
            done: isDone,
            onTap: () async {
              if (task.hasTimer) {
                await _showTimer(task);
              } else {
                ref
                    .read(appStateProvider.notifier)
                    .toggleTaskDone(widget.routineId, task.id);
              }
              _checkReward();
            },
            onChanged: (value) {
              ref
                  .read(appStateProvider.notifier)
                  .toggleTaskDone(widget.routineId, task.id, done: value);
              _checkReward();
            },
          );
        },
      ),
    );
  }
}

class _RoutineTaskCard extends StatelessWidget {
  const _RoutineTaskCard({
    required this.task,
    required this.showHelperText,
    required this.done,
    required this.onTap,
    required this.onChanged,
  });

  final RoutineTask task;
  final bool showHelperText;
  final bool done;
  final VoidCallback onTap;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: done ? Colors.green.shade100 : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.orange.shade100,
              child: Icon(iconForKey(task.icon), size: 32, color: Colors.orange),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.label,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (showHelperText)
                    Text(
                      task.hasTimer
                          ? '${task.timerSeconds ~/ 60}:00'
                          : task.label,
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                ],
              ),
            ),
            Checkbox(
              value: done,
              onChanged: (value) {
                if (value != null) {
                  onChanged(value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
