import 'package:momentum/lib.dart';

class YourTasksWidget extends StatelessWidget {
  final int totalTasks;
  final int todayTasks;
  final int pendingTasks;
  final int overdueTasks;

  const YourTasksWidget({
    super.key,
    required this.totalTasks,
    required this.todayTasks,
    required this.pendingTasks,
    required this.overdueTasks,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your tasks',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),

        Row(
          spacing: 12,
          children: [
            Expanded(
              child: StatCardWidget(
                icon: Icons.task_alt_rounded,
                value: '$totalTasks',
                label: 'Total tasks',
              ),
            ),
            Expanded(
              child: StatCardWidget(
                icon: Icons.today_rounded,
                value: '$todayTasks',
                label: 'Today',
              ),
            ),
          ],
        ),

        Row(
          spacing: 12,
          children: [
            Expanded(
              child: StatCardWidget(
                icon: Icons.pending_actions_rounded,
                value: '$pendingTasks',
                label: 'Upcoming',
              ),
            ),
            Expanded(
              child: StatCardWidget(
                icon: Icons.warning_amber_rounded,
                value: '$overdueTasks',
                label: 'Overdue',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
