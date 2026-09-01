import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTaskDatePickerWidget extends StatelessWidget {
  const NewTaskDatePickerWidget({
    super.key,
    required this.dueAt,
    required this.onPressed,
    required this.onClear,
  });

  final DateTime? dueAt;
  final VoidCallback onPressed;
  final VoidCallback onClear;

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('MMM d, yyyy • h:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        Text(
          'Pick date',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(
              Icons.calendar_today_outlined,
              color: colorScheme.primary,
            ),
            title: Text(
              dueAt == null ? 'Set due date' : _formatDateTime(dueAt!),
            ),
            trailing: dueAt == null
                ? const Icon(Icons.chevron_right_rounded)
                : IconButton(
                    onPressed: onClear,
                    icon: const Icon(Icons.close_rounded),
                  ),
            onTap: onPressed,
          ),
        ),
      ],
    );
  }
}
