import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:kids_routine_visual/data/models.dart';
import 'package:kids_routine_visual/data/storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    final tempDir = await Directory.systemTemp.createTemp('hive_test');
    Hive.init(tempDir.path);
  });

  tearDown(() async {
    await Hive.close();
  });

  test('AppStorage saves and loads state', () async {
    final box = await Hive.openBox<dynamic>('kids_routine_app');
    final storage = AppStorage(box);
    final state = storage.loadState();
    final updated = state.copyWith(activeProfileId: 'child2');
    await storage.saveState(updated);

    final loaded = storage.loadState();
    expect(loaded.activeProfileId, 'child2');
  });

  test('DailyResetService clears progress on new day', () {
    const service = DailyResetService();
    const progress = RoutineProgress(
      routineId: 'morning',
      completedTaskIds: ['one'],
      lastCompletedDate: '2024-01-01',
    );
    final profile = ProfileData(
      id: 'child1',
      name: 'Child 1',
      showHelperText: true,
      hapticsEnabled: true,
      routines: const [],
      progress: const [progress],
    );

    final reset = service.resetIfNeeded(profile, DateTime(2024, 1, 2));
    expect(reset.progress.first.completedTaskIds, isEmpty);
  });
}
