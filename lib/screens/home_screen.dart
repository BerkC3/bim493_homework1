import 'package:flutter/material.dart';

import '../data/sample_events.dart';
import '../models/campus_event.dart';
import '../state/event_store.dart';
import '../widgets/empty_state.dart';
import '../widgets/event_card.dart';
import '../widgets/search_filter_bar.dart';
import 'event_details_screen.dart';

enum HomeTab { explore, favorites, myEvents }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final EventStore _store = EventStore(sampleEvents);
  final TextEditingController _searchController = TextEditingController();
  HomeTab _currentTab = HomeTab.explore;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    setState(() => _store.searchQuery = value);
  }

  void _onCategorySelected(EventCategory? category) {
    setState(() => _store.selectedCategory = category);
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _store.searchQuery = '');
  }

  void _clearAllFilters() {
    _searchController.clear();
    setState(_store.clearFilters);
  }

  void _toggleFavorite(CampusEvent event) {
    setState(() => _store.toggleFavorite(event.id));
  }

  Future<void> _openDetails(CampusEvent event) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => EventDetailsScreen(
          event: event,
          store: _store,
          onChanged: () => setState(() {}),
        ),
      ),
    );

    if (mounted) setState(() {});
  }

  List<CampusEvent> get _visibleEvents {
    switch (_currentTab) {
      case HomeTab.explore:
        return _store.exploreEvents;
      case HomeTab.favorites:
        return _store.favoriteEvents;
      case HomeTab.myEvents:
        return _store.myEvents;
    }
  }

  String get _title {
    switch (_currentTab) {
      case HomeTab.explore:
        return 'Explore';
      case HomeTab.favorites:
        return 'Favorites';
      case HomeTab.myEvents:
        return 'My Events';
    }
  }

  @override
  Widget build(BuildContext context) {
    final events = _visibleEvents;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Campus Event Explorer',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              _title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        toolbarHeight: 72,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Chip(
              avatar: const Icon(Icons.how_to_reg_rounded, size: 18),
              label: Text('Joined: ${_store.joinedCount}'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SearchFilterBar(
            controller: _searchController,
            selectedCategory: _store.selectedCategory,
            onQueryChanged: _onQueryChanged,
            onClearSearch: _clearSearch,
            onCategorySelected: _onCategorySelected,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${events.length} matching '
                    '${events.length == 1 ? 'event' : 'events'}',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                if (_store.hasActiveFilters)
                  TextButton(
                    onPressed: _clearAllFilters,
                    child: const Text('Clear filters'),
                  ),
              ],
            ),
          ),
          Expanded(
            child: events.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    itemCount: events.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return EventCard(
                        key: ValueKey(event.id),
                        event: event,
                        availablePlaces: _store.availablePlaces(event.id),
                        isFavorite: _store.isFavorite(event.id),
                        isJoined: _store.isJoined(event.id),
                        onFavoriteToggle: () => _toggleFavorite(event),
                        onOpenDetails: () => _openDetails(event),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentTab.index,
        onDestinationSelected: (index) {
          setState(() => _currentTab = HomeTab.values[index]);
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: _store.favoriteCount > 0,
              label: Text('${_store.favoriteCount}'),
              child: const Icon(Icons.favorite_border),
            ),
            selectedIcon: Badge(
              isLabelVisible: _store.favoriteCount > 0,
              label: Text('${_store.favoriteCount}'),
              child: const Icon(Icons.favorite),
            ),
            label: 'Favorites',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: _store.joinedCount > 0,
              label: Text('${_store.joinedCount}'),
              child: const Icon(Icons.event_note_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: _store.joinedCount > 0,
              label: Text('${_store.joinedCount}'),
              child: const Icon(Icons.event_note),
            ),
            label: 'My Events',
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final hiddenByFilters = switch (_currentTab) {
      HomeTab.explore => true,
      HomeTab.favorites => _store.favoriteCount > 0,
      HomeTab.myEvents => _store.joinedCount > 0,
    };

    if (hiddenByFilters) {
      return EmptyState(
        icon: Icons.search_off_rounded,
        title: 'No matching events',
        message: _store.searchQuery.trim().isEmpty
            ? 'No events in this category. Try another category.'
            : 'No events match "${_store.searchQuery.trim()}". '
                  'Try another title or category.',
        actionLabel: 'Clear search and filters',
        onAction: _clearAllFilters,
      );
    }

    if (_currentTab == HomeTab.favorites) {
      return const EmptyState(
        icon: Icons.favorite_border_rounded,
        title: 'No favorites yet',
        message: 'Tap the heart on an event to save it here.',
      );
    }

    return const EmptyState(
      icon: Icons.event_busy_rounded,
      title: 'You have not joined any events',
      message: 'Open an event and tap "Join event" to see it here.',
    );
  }
}
