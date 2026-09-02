import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:momentum/core/core.dart';

class DateSelectorWidget extends StatefulWidget {
  const DateSelectorWidget({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  @override
  State<DateSelectorWidget> createState() => _DateSelectorWidgetState();
}

class _DateSelectorWidgetState extends State<DateSelectorWidget> {
  late DateTime selectedDate;
  int monthOffset = 0;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.selectedDate;
    monthOffset = _calculateMonthOffset(selectedDate);
  }

  @override
  void didUpdateWidget(covariant DateSelectorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selectedDate != widget.selectedDate) {
      selectedDate = widget.selectedDate;
      monthOffset = _calculateMonthOffset(selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final monthDates = generateMonthDates(monthOffset);
    final monthName = DateFormat('MMMM yyyy').format(monthDates.first);

    final today = DateTime.now();
    final isCurrentMonth =
        today.year == monthDates.first.year &&
        today.month == monthDates.first.month;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  _changeMonth(-1);
                },
                icon: const Icon(Icons.arrow_back_ios),
              ),
              Expanded(
                child: Center(
                  child: Text(monthName, style: theme.textTheme.headlineSmall),
                ),
              ),
              IconButton(
                onPressed: () {
                  _changeMonth(1);
                },
                icon: const Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
        ),

        // Today button
        if (!isCurrentMonth)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: OutlinedButton(
              onPressed: _goToToday,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                side: BorderSide(color: theme.colorScheme.outlineVariant),
              ),
              child: Text(
                'Go to Today',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            height: 80,
            child: ListView.builder(
              itemCount: monthDates.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final date = monthDates[index];

                final isSelected =
                    selectedDate.year == date.year &&
                    selectedDate.month == date.month &&
                    selectedDate.day == date.day;

                final isToday =
                    today.year == date.year &&
                    today.month == date.month &&
                    today.day == date.day;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Material(
                    color: isSelected
                        ? Colors.deepOrangeAccent
                        : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(10),
                    elevation: isSelected ? 2 : 0,
                    shadowColor: Colors.black.withValues(alpha: 0.12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        setState(() {
                          selectedDate = date;
                        });

                        widget.onDateSelected(date);
                      },
                      child: Container(
                        width: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: isSelected
                              ? null
                              : Border.all(
                                  color: isToday
                                      ? Colors.deepOrangeAccent
                                      : theme.colorScheme.outlineVariant,
                                  width: isToday ? 1.5 : 1,
                                ),
                        ),
                        child: Column(
                          spacing: 4,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat('d').format(date),
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : theme.colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              DateFormat('E').format(date),
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : theme.colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _changeMonth(int value) {
    final newOffset = monthOffset + value;
    final dates = generateMonthDates(newOffset);

    setState(() {
      monthOffset = newOffset;
      selectedDate = dates.first;
    });

    widget.onDateSelected(selectedDate);
  }

  void _goToToday() {
    final today = DateTime.now();

    setState(() {
      monthOffset = 0;
      selectedDate = today;
    });

    widget.onDateSelected(today);
  }

  int _calculateMonthOffset(DateTime date) {
    final today = DateTime.now();

    return (date.year - today.year) * 12 + date.month - today.month;
  }
}
