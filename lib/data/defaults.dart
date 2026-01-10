import 'models.dart';

const morningRoutineId = 'morning';
const eveningRoutineId = 'evening';

List<Routine> defaultRoutines() {
  return [
    Routine(
      id: morningRoutineId,
      title: 'Morning',
      tasks: const [
        RoutineTask(id: 'wake', icon: 'wb_sunny', label: 'Wake up'),
        RoutineTask(id: 'toilet', icon: 'wc', label: 'Toilet'),
        RoutineTask(id: 'wash', icon: 'wash', label: 'Wash face'),
        RoutineTask(
          id: 'brush',
          icon: 'brush',
          label: 'Brush teeth',
          hasTimer: true,
          timerSeconds: 120,
        ),
        RoutineTask(id: 'dress', icon: 'checkroom', label: 'Get dressed'),
        RoutineTask(id: 'breakfast', icon: 'restaurant', label: 'Breakfast'),
        RoutineTask(id: 'pack', icon: 'backpack', label: 'Pack bag'),
        RoutineTask(id: 'shoes', icon: 'hiking', label: 'Shoes'),
      ],
    ),
    Routine(
      id: eveningRoutineId,
      title: 'Evening',
      tasks: const [
        RoutineTask(id: 'dinner', icon: 'dinner_dining', label: 'Dinner'),
        RoutineTask(id: 'shower', icon: 'shower', label: 'Shower'),
        RoutineTask(id: 'pajamas', icon: 'bedtime', label: 'Pajamas'),
        RoutineTask(
          id: 'brush_evening',
          icon: 'brush',
          label: 'Brush teeth',
          hasTimer: true,
          timerSeconds: 120,
        ),
        RoutineTask(id: 'story', icon: 'menu_book', label: 'Story'),
        RoutineTask(
          id: 'prepare',
          icon: 'checklist',
          label: 'Prepare clothes',
        ),
        RoutineTask(id: 'sleep', icon: 'dark_mode', label: 'Sleep'),
      ],
    ),
  ];
}

List<RoutineProgress> defaultProgress() {
  return [
    const RoutineProgress(
      routineId: morningRoutineId,
      completedTaskIds: [],
      lastCompletedDate: null,
      rewardedDate: null,
    ),
    const RoutineProgress(
      routineId: eveningRoutineId,
      completedTaskIds: [],
      lastCompletedDate: null,
      rewardedDate: null,
    ),
  ];
}
