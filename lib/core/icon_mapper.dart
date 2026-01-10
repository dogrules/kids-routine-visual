import 'package:flutter/material.dart';

const availableIconKeys = [
  'wb_sunny',
  'wc',
  'wash',
  'brush',
  'checkroom',
  'restaurant',
  'backpack',
  'hiking',
  'dinner_dining',
  'shower',
  'bedtime',
  'menu_book',
  'checklist',
  'dark_mode',
  'favorite',
  'stars',
  'emoji_events',
  'cake',
  'pets',
];

IconData iconForKey(String key) {
  switch (key) {
    case 'wb_sunny':
      return Icons.wb_sunny;
    case 'wc':
      return Icons.wc;
    case 'wash':
      return Icons.wash;
    case 'brush':
      return Icons.brush;
    case 'checkroom':
      return Icons.checkroom;
    case 'restaurant':
      return Icons.restaurant;
    case 'backpack':
      return Icons.backpack;
    case 'hiking':
      return Icons.hiking;
    case 'dinner_dining':
      return Icons.dinner_dining;
    case 'shower':
      return Icons.shower;
    case 'bedtime':
      return Icons.bedtime;
    case 'menu_book':
      return Icons.menu_book;
    case 'checklist':
      return Icons.checklist;
    case 'dark_mode':
      return Icons.dark_mode;
    case 'favorite':
      return Icons.favorite;
    case 'stars':
      return Icons.stars;
    case 'emoji_events':
      return Icons.emoji_events;
    case 'cake':
      return Icons.cake;
    case 'pets':
      return Icons.pets;
    default:
      return Icons.task_alt;
  }
}
