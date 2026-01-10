import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'defaults.dart';
import 'models.dart';

const _appBoxName = 'kids_routine_app';
const _stateKey = 'state';

class AppStorage {
  AppStorage(this._box);

  final Box<dynamic> _box;

  static Future<AppStorage> init() async {
    await Hive.initFlutter();
    final box = await Hive.openBox<dynamic>(_appBoxName);
    return AppStorage(box);
  }

  AppStateData loadState() {
    final stored = _box.get(_stateKey);
    if (stored is Map) {
      return AppStateData.fromJson(Map<String, dynamic>.from(stored));
    }

    return AppStateData(
      activeProfileId: 'child1',
      profiles: [
        ProfileData(
          id: 'child1',
          name: 'Child 1',
          showHelperText: true,
          hapticsEnabled: true,
          routines: defaultRoutines(),
          progress: defaultProgress(),
        ),
        ProfileData(
          id: 'child2',
          name: 'Child 2',
          showHelperText: true,
          hapticsEnabled: true,
          routines: defaultRoutines(),
          progress: defaultProgress(),
        ),
      ],
    );
  }

  Future<void> saveState(AppStateData state) async {
    await _box.put(_stateKey, state.toJson());
  }
}
