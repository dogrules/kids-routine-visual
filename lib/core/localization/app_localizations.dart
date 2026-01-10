import 'package:flutter/widgets.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [Locale('en'), Locale('uk')];

  static const _localizedValues = {
    'en': {
      'appTitle': 'Kids Routine Visual',
      'morning': 'Morning',
      'evening': 'Evening',
      'settings': 'Settings',
      'reset': 'Reset',
      'progress': 'Progress',
      'done': 'Done',
      'rewardTitle': 'Great job!',
      'rewardDone': 'Done',
      'showHelperText': 'Show helper text for parents',
      'haptics': 'Haptics',
      'editRoutines': 'Edit routines',
      'child1': 'Child 1',
      'child2': 'Child 2',
      'routineEditor': 'Routine editor',
      'addTask': 'Add task',
      'save': 'Save',
      'delete': 'Delete',
      'hasTimer': 'Has timer',
      'timer': 'Timer',
      'start': 'Start',
      'pause': 'Pause',
      'resume': 'Resume',
      'markDone': 'Mark done?',
      'yes': 'Yes',
      'no': 'No',
      'dailyReward': 'Sticker of the day',
    },
    'uk': {
      'appTitle': 'Kids Routine Visual',
      'morning': 'Ранок',
      'evening': 'Вечір',
      'settings': 'Налаштування',
      'reset': 'Скинути',
      'progress': 'Прогрес',
      'done': 'Готово',
      'rewardTitle': 'Чудова робота!',
      'rewardDone': 'Готово',
      'showHelperText': 'Показувати підказки для батьків',
      'haptics': 'Вібрація',
      'editRoutines': 'Редагувати рутини',
      'child1': 'Дитина 1',
      'child2': 'Дитина 2',
      'routineEditor': 'Редактор рутин',
      'addTask': 'Додати задачу',
      'save': 'Зберегти',
      'delete': 'Видалити',
      'hasTimer': 'Є таймер',
      'timer': 'Таймер',
      'start': 'Старт',
      'pause': 'Пауза',
      'resume': 'Продовжити',
      'markDone': 'Позначити як виконано?',
      'yes': 'Так',
      'no': 'Ні',
      'dailyReward': 'Стікер дня',
    },
  };

  String text(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']![key] ??
        key;
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }
}

class AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales
        .any((supported) => supported.languageCode == locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}
