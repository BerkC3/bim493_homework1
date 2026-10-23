import 'package:flutter/material.dart';

import '../models/campus_event.dart';
import '../state/event_store.dart';
import '../utils/date_format.dart';
import '../widgets/availability_label.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/event_card.dart';
import '../widgets/favorite_button.dart';
import 'image_viewer_screen.dart';

class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({
    super.key,
    required this.event,
    required this.store,
    required this.onChanged,
  });

  final CampusEvent event;

  final EventStore store;

  final VoidCallback onChanged;

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  bool _dialogOpen = false;

  CampusEvent get _event => widget.event;
  EventStore get _store => widget.store;
  String get _heroTag => 'event-image-${_event.id}';

  void _toggleFavorite() {
    _store.toggleFavorite(_event.id);
    setState(() {});
    widget.onChanged();
    final added = _store.isFavorite(_event.id);
    _showMessage(added ? 'Added to favorites' : 'Removed from favorites');
  }

  Future<void> _join() async {
    if (_dialogOpen) return;
    _dialogOpen = true;
    final confirmed = await showEventConfirmDialog(
      context: context,
      title: 'Join event?',
      question: 'Do you want to join this event?',
      event: _event,
    );
    _dialogOpen = false;
    if (!confirmed || !mounted) return;

    final result = _store.join(_event.id);
    setState(() {});
    widget.onChanged();

    switch (result) {
      case JoinResult.joined:
        _showMessage('You joined "${_event.title}"');
      case JoinResult.alreadyJoined:
        _showMessage('You have already joined this event');
      case JoinResult.full:
        _showMessage('Sorry, this event is full');
    }
  }

  Future<void> _cancel() async {
    if (_dialogOpen) return;
    _dialogOpen = true;
    final confirmed = await showEventConfirmDialog(
      context: context,
      title: 'Cancel participation?',
      question: 'Your place will be released for other students.',
      event: _event,
    );
    _dialogOpen = false;
    if (!confirmed || !mounted) return;

    final cancelled = _store.cancel(_event.id);
    setState(() {});
    widget.onChanged();
    if (cancelled) {
      _showMessage('Participation cancelled. One place was released.');
    }
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
      );
  }

  void _openImageViewer() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ImageViewerScreen(
          imagePath: _event.imagePath,
          title: _event.title,
          heroTag: _heroTag,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final available = _store.availablePlaces(_event.id);
    final joined = _store.isJoined(_event.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event details'),
        actions: [
          FavoriteButton(
            isFavorite: _store.isFavorite(_event.id),
            onPressed: _toggleFavorite,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          GestureDetector(
            onDoubleTap: _openImageViewer,
            child: Stack(
              children: [
                Hero(
                  tag: _heroTag,
                  child: Image.asset(
                    _event.imagePath,
                    height: 230,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 12,
                  child: CategoryChip(category: _event.category),
                ),
                Positioned(
                  right: 12,
                  bottom: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.zoom_in_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Double-tap to enlarge',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _event.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                AvailabilityLabel(
                  availablePlaces: available,
                  capacity: _event.capacity,
                  isJoined: joined,
                ),
                const SizedBox(height: 20),
                _InfoTile(
                  icon: _event.category.icon,
                  label: 'Category',
                  value: _event.category.label,
                ),
                _InfoTile(
                  icon: Icons.calendar_today_rounded,
                  label: 'Date',
                  value: formatEventDate(_event.dateTime),
                ),
                _InfoTile(
                  icon: Icons.schedule_rounded,
                  label: 'Time',
                  value: formatEventTime(_event.dateTime),
                ),
                _InfoTile(
                  icon: Icons.place_rounded,
                  label: 'Venue',
                  value: _event.venue,
                ),
                _InfoTile(
                  icon: Icons.people_alt_rounded,
                  label: 'Total capacity',
                  value: '${_event.capacity} people',
                ),
                _InfoTile(
                  icon: Icons.event_seat_rounded,
                  label: 'Available places',
                  value: '$available',
                ),
                _InfoTile(
                  icon: Icons.tag_rounded,
                  label: 'Event ID',
                  value: _event.id,
                ),
                const SizedBox(height: 12),
                Text(
                  'About this event',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(_event.description, style: theme.textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: _ParticipationButton(
            isJoined: joined,
            canJoin: _store.canJoin(_event.id),
            onJoin: _join,
            onCancel: _cancel,
          ),
        ),
      ),
    );
  }
}

class _ParticipationButton extends StatelessWidget {
  const _ParticipationButton({
    required this.isJoined,
    required this.canJoin,
    required this.onJoin,
    required this.onCancel,
  });

  final bool isJoined;
  final bool canJoin;
  final VoidCallback onJoin;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    const size = Size.fromHeight(52);

    if (isJoined) {
      final red = Colors.red.shade700;
      return OutlinedButton.icon(
        onPressed: onCancel,
        style: OutlinedButton.styleFrom(
          minimumSize: size,
          foregroundColor: red,
          side: BorderSide(color: red),
        ),
        icon: const Icon(Icons.cancel_outlined),
        label: const Text('Cancel participation'),
      );
    }

    if (!canJoin) {
      return FilledButton.icon(
        onPressed: null,
        style: FilledButton.styleFrom(minimumSize: size),
        icon: const Icon(Icons.block_rounded),
        label: const Text('Full - cannot join'),
      );
    }

    return FilledButton.icon(
      onPressed: onJoin,
      style: FilledButton.styleFrom(minimumSize: size),
      icon: const Icon(Icons.how_to_reg_rounded),
      label: const Text('Join event'),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
