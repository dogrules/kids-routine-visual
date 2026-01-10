import 'package:collection/collection.dart';

class RoutineTask {
  const RoutineTask({
    required this.id,
    required this.icon,
    required this.label,
    this.hasTimer = false,
    this.timerSeconds = 0,
  });

  final String id;
  final String icon;
  final String label;
  final bool hasTimer;
  final int timerSeconds;

  RoutineTask copyWith({
    String? id,
    String? icon,
    String? label,
    bool? hasTimer,
    int? timerSeconds,
  }) {
    return RoutineTask(
      id: id ?? this.id,
      icon: icon ?? this.icon,
      label: label ?? this.label,
      hasTimer: hasTimer ?? this.hasTimer,
      timerSeconds: timerSeconds ?? this.timerSeconds,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'icon': icon,
      'label': label,
      'hasTimer': hasTimer,
      'timerSeconds': timerSeconds,
    };
  }

  factory RoutineTask.fromJson(Map<String, dynamic> json) {
    return RoutineTask(
      id: json['id'] as String,
      icon: json['icon'] as String,
      label: json['label'] as String,
      hasTimer: json['hasTimer'] as bool? ?? false,
      timerSeconds: json['timerSeconds'] as int? ?? 0,
    );
  }
}

class Routine {
  const Routine({
    required this.id,
    required this.title,
    required this.tasks,
  });

  final String id;
  final String title;
  final List<RoutineTask> tasks;

  Routine copyWith({
    String? id,
    String? title,
    List<RoutineTask>? tasks,
  }) {
    return Routine(
      id: id ?? this.id,
      title: title ?? this.title,
      tasks: tasks ?? this.tasks,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'tasks': tasks.map((task) => task.toJson()).toList(),
    };
  }

  factory Routine.fromJson(Map<String, dynamic> json) {
    return Routine(
      id: json['id'] as String,
      title: json['title'] as String,
      tasks: (json['tasks'] as List<dynamic>?)
              ?.map((task) => RoutineTask.fromJson(task as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}

class RoutineProgress {
  const RoutineProgress({
    required this.routineId,
    required this.completedTaskIds,
    this.lastCompletedDate,
    this.rewardedDate,
  });

  final String routineId;
  final List<String> completedTaskIds;
  final String? lastCompletedDate;
  final String? rewardedDate;

  RoutineProgress copyWith({
    String? routineId,
    List<String>? completedTaskIds,
    String? lastCompletedDate,
    String? rewardedDate,
  }) {
    return RoutineProgress(
      routineId: routineId ?? this.routineId,
      completedTaskIds: completedTaskIds ?? this.completedTaskIds,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
      rewardedDate: rewardedDate ?? this.rewardedDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'routineId': routineId,
      'completedTaskIds': completedTaskIds,
      'lastCompletedDate': lastCompletedDate,
      'rewardedDate': rewardedDate,
    };
  }

  factory RoutineProgress.fromJson(Map<String, dynamic> json) {
    return RoutineProgress(
      routineId: json['routineId'] as String,
      completedTaskIds: (json['completedTaskIds'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          const [],
      lastCompletedDate: json['lastCompletedDate'] as String?,
      rewardedDate: json['rewardedDate'] as String?,
    );
  }
}

class ProfileData {
  const ProfileData({
    required this.id,
    required this.name,
    required this.showHelperText,
    required this.hapticsEnabled,
    required this.routines,
    required this.progress,
  });

  final String id;
  final String name;
  final bool showHelperText;
  final bool hapticsEnabled;
  final List<Routine> routines;
  final List<RoutineProgress> progress;

  ProfileData copyWith({
    String? id,
    String? name,
    bool? showHelperText,
    bool? hapticsEnabled,
    List<Routine>? routines,
    List<RoutineProgress>? progress,
  }) {
    return ProfileData(
      id: id ?? this.id,
      name: name ?? this.name,
      showHelperText: showHelperText ?? this.showHelperText,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      routines: routines ?? this.routines,
      progress: progress ?? this.progress,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'showHelperText': showHelperText,
      'hapticsEnabled': hapticsEnabled,
      'routines': routines.map((routine) => routine.toJson()).toList(),
      'progress': progress.map((item) => item.toJson()).toList(),
    };
  }

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      id: json['id'] as String,
      name: json['name'] as String,
      showHelperText: json['showHelperText'] as bool? ?? true,
      hapticsEnabled: json['hapticsEnabled'] as bool? ?? true,
      routines: (json['routines'] as List<dynamic>?)
              ?.map((routine) =>
                  Routine.fromJson(routine as Map<String, dynamic>))
              .toList() ??
          const [],
      progress: (json['progress'] as List<dynamic>?)
              ?.map((item) =>
                  RoutineProgress.fromJson(item as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  RoutineProgress progressFor(String routineId) {
    return progress.firstWhere(
      (item) => item.routineId == routineId,
      orElse: () => RoutineProgress(
        routineId: routineId,
        completedTaskIds: const [],
      ),
    );
  }

  ProfileData updateProgress(RoutineProgress updated) {
    final updatedProgress = progress
        .map((item) => item.routineId == updated.routineId ? updated : item)
        .toList();
    if (!updatedProgress.any((item) => item.routineId == updated.routineId)) {
      updatedProgress.add(updated);
    }
    return copyWith(progress: updatedProgress);
  }
}

class AppStateData {
  const AppStateData({
    required this.activeProfileId,
    required this.profiles,
  });

  final String activeProfileId;
  final List<ProfileData> profiles;

  ProfileData get activeProfile => profiles.firstWhere(
        (profile) => profile.id == activeProfileId,
      );

  AppStateData copyWith({
    String? activeProfileId,
    List<ProfileData>? profiles,
  }) {
    return AppStateData(
      activeProfileId: activeProfileId ?? this.activeProfileId,
      profiles: profiles ?? this.profiles,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activeProfileId': activeProfileId,
      'profiles': profiles.map((profile) => profile.toJson()).toList(),
    };
  }

  factory AppStateData.fromJson(Map<String, dynamic> json) {
    return AppStateData(
      activeProfileId: json['activeProfileId'] as String,
      profiles: (json['profiles'] as List<dynamic>?)
              ?.map((profile) =>
                  ProfileData.fromJson(profile as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  AppStateData updateProfile(ProfileData updated) {
    final updatedProfiles = profiles
        .map((profile) => profile.id == updated.id ? updated : profile)
        .toList();
    return copyWith(profiles: updatedProfiles);
  }

  Routine? routineFor(String routineId) {
    return activeProfile.routines
        .firstWhereOrNull((routine) => routine.id == routineId);
  }
}

class DailyResetService {
  const DailyResetService();

  String todayKey(DateTime dateTime) {
    final local = dateTime.toLocal();
    return '${local.year.toString().padLeft(4, '0')}'
        '-${local.month.toString().padLeft(2, '0')}'
        '-${local.day.toString().padLeft(2, '0')}';
  }

  ProfileData resetIfNeeded(ProfileData profile, DateTime now) {
    final today = todayKey(now);
    final updatedProgress = profile.progress.map((progress) {
      if (progress.lastCompletedDate == null) {
        return progress;
      }
      if (progress.lastCompletedDate != today) {
        return progress.copyWith(
          completedTaskIds: const [],
          lastCompletedDate: today,
        );
      }
      return progress;
    }).toList();

    return profile.copyWith(progress: updatedProgress);
  }
}
