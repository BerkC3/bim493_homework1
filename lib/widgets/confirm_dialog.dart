import 'package:flutter/material.dart';

import '../models/campus_event.dart';
import '../utils/date_format.dart';

Future<bool> showEventConfirmDialog({
  required BuildContext context,
  required String title,
  required String question,
  required CampusEvent event,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      final theme = Theme.of(dialogContext);
      return AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question),
            const SizedBox(height: 16),
            Text(
              event.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            _DialogRow(
              icon: Icons.schedule_rounded,
              text: formatEventDateTime(event.dateTime),
            ),
            const SizedBox(height: 4),
            _DialogRow(icon: Icons.place_outlined, text: event.venue),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('No'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Yes'),
          ),
        ],
      );
    },
  );
  return result ?? false;
}

class _DialogRow extends StatelessWidget {
  const _DialogRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    );
  }
}
