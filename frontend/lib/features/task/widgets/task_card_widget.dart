import 'package:momentum/lib.dart';

// class TaskCardWidget extends StatelessWidget {
//   const TaskCardWidget({super.key, required this.task});
//
//   final TaskModel task;
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;
//
//     final isOverdue = task.dueAt.isBefore(DateTime.now());
//
//     return Card(
//       clipBehavior: Clip.antiAlias,
//       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       child: InkWell(
//         onTap: () {
//           Navigator.pushNamed(context, AppRoutes.newTask, arguments: task);
//         },
//         child: IntrinsicHeight(
//           child: Row(
//             children: [
//               Container(width: 5, color: task.color),
//
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Checkbox
//                       InkWell(
//                         onTap: () {
//                           // TODO: Complete task
//                         },
//                         borderRadius: BorderRadius.circular(20),
//                         child: Container(
//                           width: 24,
//                           height: 24,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             border: Border.all(
//                               color: colorScheme.outline,
//                               width: 1.5,
//                             ),
//                           ),
//                         ),
//                       ),
//
//                       const SizedBox(width: 14),
//
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               task.title,
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                               style: theme.textTheme.titleMedium?.copyWith(
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//
//                             if (task.description.isNotEmpty) ...[
//                               const SizedBox(height: 5),
//                               Text(
//                                 task.description,
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: theme.textTheme.bodyMedium?.copyWith(
//                                   color: colorScheme.onSurfaceVariant,
//                                 ),
//                               ),
//                             ],
//
//                             const SizedBox(height: 10),
//
//                             Row(
//                               children: [
//                                 Icon(
//                                   Icons.schedule_rounded,
//                                   size: 15,
//                                   color: isOverdue
//                                       ? colorScheme.error
//                                       : colorScheme.onSurfaceVariant,
//                                 ),
//                                 const SizedBox(width: 5),
//                                 Text(
//                                   _formatDueDate(task.dueAt),
//                                   style: theme.textTheme.labelMedium?.copyWith(
//                                     color: isOverdue
//                                         ? colorScheme.error
//                                         : colorScheme.onSurfaceVariant,
//                                   ),
//                                 ),
//
//                                 const SizedBox(width: 12),
//
//                                 if (!task.isSynced) ...[
//                                   Icon(
//                                     Icons.cloud_off_outlined,
//                                     size: 15,
//                                     color: colorScheme.onSurfaceVariant,
//                                   ),
//                                   const SizedBox(width: 4),
//                                   Text(
//                                     'Not synced',
//                                     style: theme.textTheme.labelMedium,
//                                   ),
//                                 ],
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//
//                       IconButton(
//                         onPressed: () {
//                           // TODO: Task menu
//                         },
//                         icon: const Icon(Icons.more_vert_rounded),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   String _formatDueDate(DateTime date) {
//     final now = DateTime.now();
//
//     if (date.year == now.year &&
//         date.month == now.month &&
//         date.day == now.day) {
//       final hour = date.hour.toString().padLeft(2, '0');
//       final minute = date.minute.toString().padLeft(2, '0');
//
//       return 'Today, $hour:$minute';
//     }
//
//     return '${date.day}/${date.month}/${date.year}';
//   }
// }

class TaskCardWidget extends StatelessWidget {
  const TaskCardWidget({super.key, required this.task});

  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      spacing: 8,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Material(
              color: task.color,
              borderRadius: BorderRadius.circular(16),
              elevation: 0,
              shadowColor: Colors.black.withValues(alpha: 0.08),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.newTask,
                    arguments: task,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 4,
                    children: [
                      Text(
                        task.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          height: 1.15,
                        ),
                      ),
                      Text(
                        task.description,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        // Row(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     Container(
        //       height: 10,
        //       width: 10,
        //       decoration: BoxDecoration(
        //         color: strengthenColor(task.color, 0.69),
        //         shape: BoxShape.circle,
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.all(12.0),
        //       child: Text(
        //         task.formatDueTime,
        //         style: theme.textTheme.bodyLarge?.copyWith(
        //           fontWeight: FontWeight.w600,
        //           color: theme.colorScheme.onSurface,
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                color: strengthenColor(task.color, 0.69),
                shape: BoxShape.circle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 6,
                children: [
                  Icon(
                    task.isSynced
                        ? Icons.cloud_done_outlined
                        : Icons.cloud_upload_outlined,
                    size: 18,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  Text(
                    task.formatDueTime,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
