import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/defaults.dart';
import '../../data/models.dart';
import '../../data/storage.dart';

final storageProvider = Provider<AppStorage>((ref) {
  throw UnimplementedError('Storage not initialized');
});

final appStateProvider = StateNotifierProvider<AppStateNotifier, AppStateData>(
  (ref) => AppStateNotifier(ref.read(storageProvider)),
);

class AppStateNotifier extends StateNotifier<AppStateData> {
  AppStateNotifier(this._storage) : super(_storage.loadState()) {
    _applyDailyReset();
  }

  final AppStorage _storage;
  final DailyResetService _resetService = const DailyResetService();

  Future<void> _persist() async {
    await _storage.saveState(state);
  }

  void _applyDailyReset() {
    final now = DateTime.now();
    final updatedProfiles = state.profiles
        .map((profile) => _resetService.resetIfNeeded(profile, now))
        .toList();
    state = state.copyWith(profiles: updatedProfiles);
    _persist();
  }

  void setActiveProfile(String profileId) {
    state = state.copyWith(activeProfileId: profileId);
    _persist();
  }

  void toggleHelperText(bool value) {
    final profile = state.activeProfile.copyWith(showHelperText: value);
    state = state.updateProfile(profile);
    _persist();
  }

  void toggleHaptics(bool value) {
    final profile = state.activeProfile.copyWith(hapticsEnabled: value);
    state = state.updateProfile(profile);
    _persist();
  }

  void resetRoutine(String routineId) {
    final today = _resetService.todayKey(DateTime.now());
    final progress = state.activeProfile
        .progressFor(routineId)
        .copyWith(completedTaskIds: const [], lastCompletedDate: today);
    final profile = state.activeProfile.updateProgress(progress);
    state = state.updateProfile(profile);
    _persist();
  }

  void toggleTaskDone(String routineId, String taskId, {bool? done}) {
    final progress = state.activeProfile.progressFor(routineId);
    final completed = progress.completedTaskIds.toSet();
    final shouldComplete = done ?? !completed.contains(taskId);
    if (shouldComplete) {
      completed.add(taskId);
      if (state.activeProfile.hapticsEnabled) {
        HapticFeedback.selectionClick();
      }
    } else {
      completed.remove(taskId);
    }
    final today = _resetService.todayKey(DateTime.now());
    final updatedProgress = progress.copyWith(
      completedTaskIds: completed.toList(),
      lastCompletedDate: today,
    );
    final profile = state.activeProfile.updateProgress(updatedProgress);
    state = state.updateProfile(profile);
    _persist();
  }

  bool isRoutineComplete(String routineId) {
    final routine = state.activeProfile.routines
        .firstWhere((routine) => routine.id == routineId);
    final progress = state.activeProfile.progressFor(routineId);
    return progress.completedTaskIds.length == routine.tasks.length;
  }

  bool rewardAvailable(String routineId) {
    final today = _resetService.todayKey(DateTime.now());
    final progress = state.activeProfile.progressFor(routineId);
    return isRoutineComplete(routineId) && progress.rewardedDate != today;
  }

  void markRewarded(String routineId) {
    final today = _resetService.todayKey(DateTime.now());
    final progress = state.activeProfile
        .progressFor(routineId)
        .copyWith(rewardedDate: today);
    final profile = state.activeProfile.updateProgress(progress);
    state = state.updateProfile(profile);
    _persist();
  }

  void updateRoutine(String routineId, List<RoutineTask> tasks) {
    final routines = state.activeProfile.routines.map((routine) {
      if (routine.id == routineId) {
        return routine.copyWith(tasks: tasks);
      }
      return routine;
    }).toList();
    final updatedProfile = state.activeProfile.copyWith(routines: routines);
    state = state.updateProfile(updatedProfile);
    _persist();
  }

  void resetDefaults() {
    final updatedProfile = state.activeProfile.copyWith(
      routines: defaultRoutines(),
      progress: defaultProgress(),
    );
    state = state.updateProfile(updatedProfile);
    _persist();
  }
}
