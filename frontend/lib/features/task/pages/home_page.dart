import 'package:momentum/lib.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   DateTime selectedDate = DateTime.now();
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Momentum',
//           style: TextStyle(fontWeight: FontWeight.w700),
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.pushNamed(context, AppRoutes.profile);
//             },
//             icon: const Icon(Icons.person_outline_rounded),
//           ),
//           const SizedBox(width: 8),
//         ],
//       ),
//       body: SafeArea(
//         child: BlocBuilder<TasksCubit, TasksState>(
//           builder: (context, state) {
//             if (state is TasksLoading) {
//               return const Center(child: CircularProgressIndicator());
//             }
//
//             if (state is TaskListError) {
//               return Center(child: Text(state.message));
//             }
//
//             if (state is! TasksLoaded) {
//               return const SizedBox.shrink();
//             }
//
//             final tasks = state.tasks;
//
//             // final filteredTasks = tasks.where((task) {
//             //   return task.dueAt.year == selectedDate.year &&
//             //       task.dueAt.month == selectedDate.month &&
//             //       task.dueAt.day == selectedDate.day;
//             // }).toList();
//
//             return ListView(
//               padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
//               children: [
//                 Text(
//                   'Stay focused.',
//                   style: theme.textTheme.headlineMedium?.copyWith(
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//
//                 const SizedBox(height: 6),
//
//                 Text(
//                   'Turn your plans into progress.',
//                   style: theme.textTheme.bodyLarge?.copyWith(
//                     color: colorScheme.onSurfaceVariant,
//                   ),
//                 ),
//
//                 const SizedBox(height: 24),
//
//                 TextField(
//                   readOnly: true,
//                   onTap: () {
//                     // TODO: Search tasks
//                   },
//                   decoration: const InputDecoration(
//                     hintText: 'Search tasks...',
//                     prefixIcon: Icon(Icons.search_rounded),
//                   ),
//                 ),
//
//                 const SizedBox(height: 28),
//
//                 Row(
//                   children: [
//                     Expanded(
//                       child: QuickActionCardWidget(
//                         icon: Icons.add_rounded,
//                         title: 'New Task',
//                         subtitle: 'Capture an idea',
//                         onTap: () {
//                           Navigator.pushNamed(context, AppRoutes.newTask);
//                         },
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: QuickActionCardWidget(
//                         icon: Icons.push_pin_outlined,
//                         title: 'Pinned',
//                         subtitle: 'Important tasks',
//                         onTap: () {
//                           // TODO: Open pinned tasks
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 const SizedBox(height: 32),
//
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Today',
//                       style: theme.textTheme.titleLarge?.copyWith(
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     Text(
//                       '${tasks.length} tasks',
//                       style: theme.textTheme.bodyMedium?.copyWith(
//                         color: colorScheme.onSurfaceVariant,
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 const SizedBox(height: 12),
//
//                 TodaysProgressWidget(completed: 0, total: tasks.length),
//
//                 const SizedBox(height: 28),
//
//                 Text(
//                   'Your tasks',
//                   style: theme.textTheme.titleLarge?.copyWith(
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//
//                 const SizedBox(height: 12),
//
//                 if (tasks.isEmpty)
//                   const Padding(
//                     padding: EdgeInsets.symmetric(vertical: 40),
//                     child: Center(child: Text('No tasks for this date')),
//                   )
//                 else
//                   ...tasks.map(
//                     (task) => Padding(
//                       padding: const EdgeInsets.only(bottom: 12),
//                       child: TaskCardWidget(task: task),
//                     ),
//                   ),
//               ],
//             );
//           },
//         ),
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {
//           Navigator.pushNamed(context, AppRoutes.newTask);
//         },
//         icon: const Icon(Icons.add_rounded),
//         label: const Text('New task'),
//       ),
//     );
//   }
// }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.newTask);
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('New task'),
      ),
      appBar: AppBar(
        title: const Text('My Tasks'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.profile);
            },
            icon: const Icon(Icons.person_outline_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        spacing: 12,
        children: [
          DateSelectorWidget(
            selectedDate: selectedDate,
            onDateSelected: (date) {
              setState(() {
                selectedDate = date;
              });
            },
          ),

          Expanded(
            child: BlocBuilder<TasksCubit, TasksState>(
              builder: (context, state) {
                return switch (state) {
                  TasksInitial() => const SizedBox.shrink(),

                  TasksLoading() => const Center(
                    child: CircularProgressIndicator(),
                  ),

                  TasksLoaded(:final tasks) => Builder(
                    builder: (context) {
                      final filteredTasks = tasks.where((task) {
                        return task.dueAt.year == selectedDate.year &&
                            task.dueAt.month == selectedDate.month &&
                            task.dueAt.day == selectedDate.day;
                      }).toList();

                      return ListView.builder(
                        itemCount: filteredTasks.length,
                        itemBuilder: (context, index) {
                          final task = filteredTasks[index];

                          return TaskCardWidget(task: task);
                        },
                      );
                    },
                  ),

                  TaskListError(:final message) => Center(child: Text(message)),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}
