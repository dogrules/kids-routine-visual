import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/localization/app_localizations.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/routine_editor_screen.dart';
import 'presentation/screens/routine_screen.dart';
import 'presentation/screens/settings_screen.dart';
import 'presentation/state/app_state_notifier.dart';

class KidsRoutineApp extends ConsumerWidget {
  const KidsRoutineApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider);
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/routine/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return RoutineScreen(routineId: id);
          },
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: '/editor/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return RoutineEditorScreen(routineId: id);
          },
        ),
      ],
    );

    return MaterialApp.router(
      title: 'Kids Routine Visual',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          primary: Colors.orange,
          secondary: Colors.teal,
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 18),
          bodyMedium: TextStyle(fontSize: 16),
        ),
        useMaterial3: true,
      ),
      routerConfig: router,
      locale: Locale(appState.activeProfileId == 'child2' ? 'uk' : 'en'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
