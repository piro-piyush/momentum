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
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            children: [
              Material(
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.55,
                ),
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _changeMonth(-1),
                  child: const SizedBox(
                    width: 42,
                    height: 42,
                    child: Icon(Icons.chevron_left_rounded, size: 24),
                  ),
                ),
              ),

              Expanded(
                child: Column(
                  children: [
                    Text(
                      monthName,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      DateFormat(
                        'yyyy',
                      ).format(DateTime(selectedDate.year, selectedDate.month)),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              Material(
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.55,
                ),
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _changeMonth(1),
                  child: const SizedBox(
                    width: 42,
                    height: 42,
                    child: Icon(Icons.chevron_right_rounded, size: 24),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Today button
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: !isCurrentMonth
              ? Padding(
                  key: const ValueKey('today'),
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Material(
                    color: theme.colorScheme.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      onTap: _goToToday,
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.today_rounded,
                              size: 16,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Today',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox(key: ValueKey('empty'), height: 12),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            height: 82,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: monthDates.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
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

                return Material(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(14),
                  elevation: isSelected ? 3 : 0,
                  shadowColor: theme.colorScheme.primary.withValues(
                    alpha: 0.25,
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      setState(() {
                        selectedDate = date;
                      });

                      widget.onDateSelected(date);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOutCubic,
                      width: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : isToday
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outlineVariant.withValues(
                                  alpha: 0.65,
                                ),
                          width: isToday && !isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('d').format(date),
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: isSelected
                                  ? theme.colorScheme.onPrimary
                                  : theme.colorScheme.onSurface,
                              fontWeight: FontWeight.w700,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            DateFormat('EEE').format(date).toUpperCase(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: isSelected
                                  ? theme.colorScheme.onPrimary.withValues(
                                      alpha: 0.85,
                                    )
                                  : theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.6,
                            ),
                          ),

                          if (isToday && !isSelected) ...[
                            const SizedBox(height: 5),
                            Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
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
