import '../models/campus_event.dart';

enum JoinResult { joined, alreadyJoined, full }

class EventStore {
  EventStore(List<CampusEvent> events)
    : events = List.unmodifiable(
        [...events]..sort((a, b) => a.dateTime.compareTo(b.dateTime)),
      ),
      _availablePlaces = {
        for (final event in events) event.id: event.initialAvailablePlaces,
      };

  final List<CampusEvent> events;

  final Map<String, int> _availablePlaces;
  final Set<String> _favoriteIds = {};
  final Set<String> _joinedIds = {};

  String searchQuery = '';

  EventCategory? selectedCategory;

  int availablePlaces(String eventId) => _availablePlaces[eventId] ?? 0;

  bool isFavorite(String eventId) => _favoriteIds.contains(eventId);

  bool isJoined(String eventId) => _joinedIds.contains(eventId);

  bool isFull(String eventId) =>
      !isJoined(eventId) && availablePlaces(eventId) == 0;

  bool canJoin(String eventId) =>
      !isJoined(eventId) && availablePlaces(eventId) > 0;

  int get joinedCount => _joinedIds.length;

  int get favoriteCount => _favoriteIds.length;

  bool get hasActiveFilters =>
      searchQuery.trim().isNotEmpty || selectedCategory != null;

  bool matchesFilters(CampusEvent event) {
    final query = searchQuery.trim().toLowerCase();
    final matchesTitle =
        query.isEmpty || event.title.toLowerCase().contains(query);
    final matchesCategory =
        selectedCategory == null || event.category == selectedCategory;
    return matchesTitle && matchesCategory;
  }

  List<CampusEvent> get exploreEvents => events.where(matchesFilters).toList();

  List<CampusEvent> get favoriteEvents =>
      events.where((e) => isFavorite(e.id) && matchesFilters(e)).toList();

  List<CampusEvent> get myEvents =>
      events.where((e) => isJoined(e.id) && matchesFilters(e)).toList();

  void toggleFavorite(String eventId) {
    if (!_favoriteIds.remove(eventId)) {
      _favoriteIds.add(eventId);
    }
  }

  JoinResult join(String eventId) {
    if (isJoined(eventId)) return JoinResult.alreadyJoined;
    final places = availablePlaces(eventId);
    if (places <= 0) return JoinResult.full;
    _joinedIds.add(eventId);
    _availablePlaces[eventId] = places - 1;
    return JoinResult.joined;
  }

  bool cancel(String eventId) {
    if (!_joinedIds.remove(eventId)) return false;
    final event = events.firstWhere((e) => e.id == eventId);
    final restored = availablePlaces(eventId) + 1;
    _availablePlaces[eventId] = restored > event.capacity
        ? event.capacity
        : restored;
    return true;
  }

  void clearFilters() {
    searchQuery = '';
    selectedCategory = null;
  }
}
