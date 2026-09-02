import 'package:momentum/lib.dart';

class ScheduleDatePickerWidget extends StatelessWidget {
  final DateTime? dueAt;
  final void Function() onPressed;
  final void Function() onClear;

  const ScheduleDatePickerWidget({
    super.key,
    this.dueAt,
    required this.onPressed,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final mutedColor = isDark
        ? const Color(0xFF9A9A9A)
        : const Color(0xFF6B6B6B);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SCHEDULE',
          style: theme.textTheme.labelSmall?.copyWith(
            color: mutedColor,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),

        const SizedBox(height: 10),

        NewTaskDatePickerWidget(
          dueAt: dueAt,
          onPressed: onPressed,
          onClear: onClear,
        ),
      ],
    );
  }
}
