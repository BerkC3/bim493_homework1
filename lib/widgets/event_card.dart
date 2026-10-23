import 'package:flutter/material.dart';

import '../models/campus_event.dart';
import '../utils/date_format.dart';
import 'availability_label.dart';
import 'favorite_button.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.event,
    required this.availablePlaces,
    required this.isFavorite,
    required this.isJoined,
    required this.onFavoriteToggle,
    required this.onOpenDetails,
  });

  final CampusEvent event;
  final int availablePlaces;
  final bool isFavorite;
  final bool isJoined;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onOpenDetails;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: InkWell(
        onTap: onOpenDetails,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(
                  event.imagePath,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  left: 12,
                  top: 12,
                  child: CategoryChip(category: event.category),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: FavoriteButton(
                    isFavorite: isFavorite,
                    onPressed: onFavoriteToggle,
                    filledBackground: true,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _IconText(
                    icon: Icons.schedule_rounded,
                    text: formatEventDateTime(event.dateTime),
                  ),
                  const SizedBox(height: 2),
                  _IconText(icon: Icons.place_outlined, text: event.venue),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: AvailabilityLabel(
                          availablePlaces: availablePlaces,
                          capacity: event.capacity,
                          isJoined: isJoined,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: onOpenDetails,
                        icon: const Icon(Icons.info_outline_rounded, size: 18),
                        label: const Text('Details'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  const CategoryChip({super.key, required this.category});

  final EventCategory category;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(category.icon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            category.label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _IconText extends StatelessWidget {
  const _IconText({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: color, fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
