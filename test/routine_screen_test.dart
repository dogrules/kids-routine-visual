import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kids_routine_visual/data/defaults.dart';
import 'package:kids_routine_visual/data/models.dart';
import 'package:kids_routine_visual/data/storage.dart';
import 'package:kids_routine_visual/presentation/screens/routine_screen.dart';
import 'package:kids_routine_visual/presentation/state/app_state_notifier.dart';

class _FakeStorage implements AppStorage {
  AppStateData _state = AppStateData(
    activeProfileId: 'child1',
    profiles: [
      ProfileData(
        id: 'child1',
        name: 'Child 1',
        showHelperText: true,
        hapticsEnabled: false,
        routines: defaultRoutines(),
        progress: defaultProgress(),
      ),
    ],
  );

  @override
  AppStateData loadState() => _state;

  @override
  Future<void> saveState(AppStateData state) async {
    _state = state;
  }
}

void main() {
  testWidgets('Routine screen shows progress', (tester) async {
    final storage = _FakeStorage();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          storageProvider.overrideWithValue(storage),
        ],
        child: const MaterialApp(
          home: RoutineScreen(routineId: morningRoutineId),
        ),
      ),
    );

    expect(find.text('0/8'), findsOneWidget);
    await tester.tap(find.byType(Checkbox).first);
    await tester.pump();
    expect(find.text('1/8'), findsOneWidget);
  });
}
