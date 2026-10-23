import 'package:flutter/material.dart';

class AvailabilityLabel extends StatelessWidget {
  const AvailabilityLabel({
    super.key,
    required this.availablePlaces,
    required this.capacity,
    required this.isJoined,
  });

  final int availablePlaces;
  final int capacity;
  final bool isJoined;

  @override
  Widget build(BuildContext context) {
    final String text;
    final Color color;
    final IconData icon;

    if (availablePlaces == 0 && !isJoined) {
      text = 'Full';
      color = Colors.red.shade700;
      icon = Icons.block_rounded;
    } else if (availablePlaces == 0) {
      text = 'No places left';
      color = Colors.blueGrey.shade600;
      icon = Icons.event_busy_rounded;
    } else if (availablePlaces == 1) {
      text = '1 place left';
      color = Colors.orange.shade800;
      icon = Icons.local_fire_department_rounded;
    } else {
      text = '$availablePlaces / $capacity places left';
      color = Colors.green.shade700;
      icon = Icons.event_available_rounded;
    }

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        _Pill(text: text, color: color, icon: icon),
        if (isJoined)
          _Pill(
            text: 'Joined',
            color: Theme.of(context).colorScheme.primary,
            icon: Icons.check_circle_rounded,
          ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text, required this.color, required this.icon});

  final String text;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
