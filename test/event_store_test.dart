import 'package:berkcuce_hw1/data/sample_events.dart';
import 'package:berkcuce_hw1/models/campus_event.dart';
import 'package:berkcuce_hw1/state/event_store.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late EventStore store;

  setUp(() => store = EventStore(sampleEvents));

  group('sample data', () {
    test('meets the assignment rules', () {
      expect(store.events.length, greaterThanOrEqualTo(6));
      expect(
        store.events.map((e) => e.category).toSet().length,
        greaterThanOrEqualTo(3),
      );
      expect(store.events.map((e) => e.id).toSet().length, store.events.length);
      expect(
        store.events.map((e) => e.imagePath).toSet().length,
        greaterThanOrEqualTo(3),
      );
      expect(store.events.any((e) => e.initialAvailablePlaces == 0), isTrue);
      expect(store.events.any((e) => e.initialAvailablePlaces == 1), isTrue);
      final deadline = DateTime(2026, 10, 25, 23, 59);
      for (final e in store.events) {
        expect(e.dateTime.isAfter(deadline), isTrue, reason: e.id);
        expect(e.initialAvailablePlaces, inInclusiveRange(0, e.capacity));
      }
    });
  });

  group('join and cancel', () {
    test('join takes one place only once', () {
      expect(store.join('e01'), JoinResult.joined);
      expect(store.availablePlaces('e01'), 11);
      expect(store.join('e01'), JoinResult.alreadyJoined);
      expect(store.availablePlaces('e01'), 11);
      expect(store.joinedCount, 1);
      expect(store.myEvents.where((e) => e.id == 'e01').length, 1);
    });

    test('full event cannot be joined', () {
      expect(store.isFull('e02'), isTrue);
      expect(store.canJoin('e02'), isFalse);
      expect(store.join('e02'), JoinResult.full);
      expect(store.availablePlaces('e02'), 0);
      expect(store.joinedCount, 0);
    });

    test('student who takes the last place can still cancel', () {
      expect(store.join('e03'), JoinResult.joined);
      expect(store.availablePlaces('e03'), 0);
      expect(store.isFull('e03'), isFalse);
      expect(store.cancel('e03'), isTrue);
      expect(store.availablePlaces('e03'), 1);
      expect(store.isJoined('e03'), isFalse);
      expect(store.myEvents, isEmpty);
    });

    test('cancel without joining changes nothing', () {
      expect(store.cancel('e01'), isFalse);
      expect(store.availablePlaces('e01'), 12);
    });
  });

  group('favorites', () {
    test('toggle does not affect participation or capacity', () {
      store.toggleFavorite('e04');
      expect(store.isFavorite('e04'), isTrue);
      expect(store.favoriteEvents.single.id, 'e04');
      expect(store.availablePlaces('e04'), 64);
      expect(store.isJoined('e04'), isFalse);
      store.toggleFavorite('e04');
      expect(store.favoriteEvents, isEmpty);
    });
  });

  group('search and filter', () {
    test('search ignores case and surrounding spaces', () {
      store.searchQuery = '   JAZZ  ';
      expect(store.exploreEvents.single.id, 'e04');
    });

    test('search and category work together', () {
      store.searchQuery = 'campus';
      expect(store.exploreEvents.length, 1);
      store.searchQuery = 'a';
      expect(store.exploreEvents.length, 6);
      store.selectedCategory = EventCategory.arts;
      expect(store.exploreEvents.single.id, 'e04');
      store.selectedCategory = EventCategory.social;
      expect(store.exploreEvents.single.id, 'e07');
      store.searchQuery = 'jazz';
      expect(store.exploreEvents, isEmpty);
    });

    test('filters also apply to favorites and my events', () {
      store.toggleFavorite('e01');
      store.toggleFavorite('e05');
      store.join('e05');
      store.selectedCategory = EventCategory.technology;
      expect(store.favoriteEvents.single.id, 'e01');
      expect(store.myEvents, isEmpty);
      store.clearFilters();
      expect(store.favoriteEvents.length, 2);
      expect(store.myEvents.single.id, 'e05');
    });
  });
}
