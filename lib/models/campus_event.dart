import 'package:flutter/material.dart';

enum EventCategory {
  technology('Technology', Icons.memory_rounded),
  arts('Arts', Icons.palette_rounded),
  sports('Sports', Icons.sports_basketball_rounded),
  social('Social', Icons.groups_rounded);

  const EventCategory(this.label, this.icon);

  final String label;
  final IconData icon;
}

class CampusEvent {
  const CampusEvent({
    required this.id,
    required this.title,
    required this.category,
    required this.dateTime,
    required this.venue,
    required this.description,
    required this.imagePath,
    required this.capacity,
    required this.initialAvailablePlaces,
  }) : assert(capacity > 0),
       assert(initialAvailablePlaces >= 0),
       assert(initialAvailablePlaces <= capacity);

  final String id;
  final String title;
  final EventCategory category;
  final DateTime dateTime;
  final String venue;
  final String description;
  final String imagePath;
  final int capacity;
  final int initialAvailablePlaces;
}
