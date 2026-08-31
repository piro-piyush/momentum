import 'package:flutter/material.dart';

class NewTaskPage extends StatefulWidget {
  const NewTaskPage({super.key});

  @override
  State<NewTaskPage> createState() => _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage> {
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;

  DateTime? dueAt;
  Color selectedColor = Colors.blue;

  final colors = <Color>[
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.red,
    Colors.purple,
    Colors.teal,
  ];

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New task',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          TextButton(onPressed: _saveTask, child: const Text('Save')),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: [
          TextField(
            controller: titleController,
            textInputAction: TextInputAction.next,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            decoration: const InputDecoration(
              hintText: 'Task title',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: descriptionController,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            minLines: 5,
            maxLines: 10,
            decoration: const InputDecoration(
              hintText: 'Add a description...',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),

          const SizedBox(height: 32),

          // Due date
          Text(
            'Due date',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

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
                      onPressed: () {
                        setState(() {
                          dueAt = null;
                        });
                      },
                      icon: const Icon(Icons.close_rounded),
                    ),
              onTap: _pickDueDate,
            ),
          ),

          const SizedBox(height: 28),

          // Color
          Text(
            'Task color',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: colors.map((color) {
              final isSelected = selectedColor == color;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedColor = color;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(color: colorScheme.onSurface, width: 3)
                        : null,
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 22,
                        )
                      : null,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 5, 12, 31),
      initialDate: dueAt ?? now,
    );

    if (date == null || !mounted) {
      return;
    }

    final time = await showTimePicker(
      context: context,
      initialTime: dueAt != null
          ? TimeOfDay.fromDateTime(dueAt!)
          : TimeOfDay.now(),
    );

    if (time == null || !mounted) {
      return;
    }

    setState(() {
      dueAt = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  void _saveTask() {
    FocusScope.of(context).unfocus();

    final title = titleController.text.trim();
    final description = descriptionController.text.trim();

    if (title.isEmpty) {
      return;
    }
    if (description.isEmpty) {
      return;
    }
    // TODO:
    // Create TaskModel through your TaskCubit/repository.
    //
    // TaskModel(
    //   id: generated locally,
    //   uid: currentUser.id,
    //   title: title,
    //   description: description,
    //   createdAt: DateTime.now(),
    //   updatedAt: DateTime.now(),
    //   dueAt: dueAt ?? DateTime.now(),
    //   color: selectedColor,
    //   isSynced: false,
    // );

    Navigator.pop(context);
  }

  String _formatDateTime(DateTime date) {
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';

    return '${date.day}/${date.month}/${date.year} • '
        '$hour:$minute $period';
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
