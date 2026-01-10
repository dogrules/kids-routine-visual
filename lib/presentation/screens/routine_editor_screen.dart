import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/icon_mapper.dart';
import '../../core/localization/app_localizations.dart';
import '../../data/models.dart';
import '../state/app_state_notifier.dart';

class RoutineEditorScreen extends ConsumerStatefulWidget {
  const RoutineEditorScreen({super.key, required this.routineId});

  final String routineId;

  @override
  ConsumerState<RoutineEditorScreen> createState() =>
      _RoutineEditorScreenState();
}

class _RoutineEditorScreenState extends ConsumerState<RoutineEditorScreen> {
  late List<RoutineTask> _tasks;

  @override
  void initState() {
    super.initState();
    final routine = ref
        .read(appStateProvider)
        .activeProfile
        .routines
        .firstWhere((routine) => routine.id == widget.routineId);
    _tasks = List<RoutineTask>.from(routine.tasks);
  }

  Future<void> _showTaskDialog({RoutineTask? existing}) async {
    final strings = AppLocalizations.of(context);
    final nameController =
        TextEditingController(text: existing?.label ?? '');
    String iconKey = existing?.icon ?? availableIconKeys.first;
    bool hasTimer = existing?.hasTimer ?? false;
    int timerSeconds = existing?.timerSeconds ?? 120;

    final result = await showDialog<RoutineTask>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(existing == null
                  ? strings.text('addTask')
                  : strings.text('save')),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Label'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: iconKey,
                      items: availableIconKeys
                          .map((key) => DropdownMenuItem(
                                value: key,
                                child: Row(
                                  children: [
                                    Icon(iconForKey(key)),
                                    const SizedBox(width: 12),
                                    Text(key),
                                  ],
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => iconKey = value);
                        }
                      },
                      decoration: const InputDecoration(labelText: 'Icon'),
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      value: hasTimer,
                      onChanged: (value) {
                        setState(() => hasTimer = value);
                      },
                      title: Text(strings.text('hasTimer')),
                    ),
                    if (hasTimer)
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Timer seconds',
                        ),
                        onChanged: (value) {
                          timerSeconds = int.tryParse(value) ?? 120;
                        },
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(strings.text('no')),
                ),
                TextButton(
                  onPressed: () {
                    final label = nameController.text.trim();
                    if (label.isEmpty) {
                      return;
                    }
                    Navigator.of(context).pop(
                      RoutineTask(
                        id: existing?.id ??
                            '${DateTime.now().millisecondsSinceEpoch}',
                        icon: iconKey,
                        label: label,
                        hasTimer: hasTimer,
                        timerSeconds: timerSeconds,
                      ),
                    );
                  },
                  child: Text(strings.text('save')),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        if (existing == null) {
          _tasks.add(result);
        } else {
          final index = _tasks.indexWhere((task) => task.id == existing.id);
          if (index != -1) {
            _tasks[index] = result;
          }
        }
      });
    }
  }

  void _save() {
    ref.read(appStateProvider.notifier).updateRoutine(widget.routineId, _tasks);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.text('routineEditor')),
        actions: [
          IconButton(
            onPressed: _save,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskDialog(),
        child: const Icon(Icons.add),
      ),
      body: ReorderableListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _tasks.length,
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) {
              newIndex -= 1;
            }
            final item = _tasks.removeAt(oldIndex);
            _tasks.insert(newIndex, item);
          });
        },
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return Card(
            key: ValueKey(task.id),
            child: ListTile(
              leading: Icon(iconForKey(task.icon)),
              title: Text(task.label),
              subtitle: Text(task.hasTimer
                  ? 'Timer ${task.timerSeconds}s'
                  : 'No timer'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _showTaskDialog(existing: task),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _tasks.removeAt(index);
                      });
                    },
                  ),
                  const Icon(Icons.drag_handle),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
