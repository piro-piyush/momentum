import 'package:momentum/lib.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoggedOut) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.login,
            (route) => false,
          );
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthChecking) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is! AuthLoggedIn) {
            return const SizedBox.shrink();
          }

          final user = state.user;

          return BlocBuilder<TasksCubit, TasksState>(
            builder: (context, taskState) {
              final tasks = taskState is TasksLoaded
                  ? taskState.tasks
                  : <TaskModel>[];

              final totalTasks = tasks.length;

              final pendingTasks = tasks.where((task) {
                return task.dueAt.isAfter(DateTime.now());
              }).length;

              final overdueTasks = tasks.where((task) {
                return task.dueAt.isBefore(DateTime.now());
              }).length;

              final todayTasks = tasks.where((task) {
                final now = DateTime.now();

                return task.dueAt.year == now.year &&
                    task.dueAt.month == now.month &&
                    task.dueAt.day == now.day;
              }).length;

              return Scaffold(
                appBar: AppBar(
                  title: const Text(
                    'Profile',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                body: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                  children: [
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 42,
                            backgroundColor: colorScheme.primaryContainer,
                            child: Icon(
                              Icons.person_rounded,
                              size: 42,
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            user.name,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.email,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    Text(
                      'Your tasks',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: StatCardWidget(
                            icon: Icons.task_alt_rounded,
                            value: '$totalTasks',
                            label: 'Total tasks',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: StatCardWidget(
                            icon: Icons.today_rounded,
                            value: '$todayTasks',
                            label: 'Today',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: StatCardWidget(
                            icon: Icons.pending_actions_rounded,
                            value: '$pendingTasks',
                            label: 'Upcoming',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: StatCardWidget(
                            icon: Icons.warning_amber_rounded,
                            value: '$overdueTasks',
                            label: 'Overdue',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    Text(
                      'Overview',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'You have $totalTasks tasks',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$todayTasks scheduled for today • '
                              '$pendingTasks upcoming • '
                              '$overdueTasks overdue',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    FilledButton.icon(
                      onPressed: () => _showLogoutDialog(context),

                      icon: const Icon(Icons.logout_rounded),
                      label: const Text('Log out'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Log out?'),
          content: const Text('Are you sure you want to log out of Momentum?'),

          actions: [
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<AuthCubit>().logout();
              },
              child: const Text('Log out'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
