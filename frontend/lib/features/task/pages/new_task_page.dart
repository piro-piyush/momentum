import 'package:momentum/lib.dart';

class NewTaskPage extends StatefulWidget {
  const NewTaskPage({super.key});

  @override
  State<NewTaskPage> createState() => _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage> {
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;

  final formKey = GlobalKey<FormState>();

  DateTime? dueAt;

  Color selectedColor = const Color.fromRGBO(246, 222, 194, 1);
  TaskModel? task;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (task != null) {
      return;
    }

    final argument = ModalRoute.of(context)?.settings.arguments;

    if (argument is TaskModel) {
      task = argument;

      titleController.text = argument.title;
      descriptionController.text = argument.description;
      dueAt = argument.dueAt;
      selectedColor = argument.color;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = task != null;
    return BlocConsumer<TaskMutationCubit, TaskMutationState>(
      listener: (context, state) {
        if (state is TaskCreated) {
          context.read<TasksCubit>().addTask(state.task);

          SnackBarUtils.success(context, 'Task created successfully');
          Navigator.pop(context);
        }

        if (state is TaskUpdated) {
          context.read<TasksCubit>().updateTask(state.task);

          SnackBarUtils.success(context, 'Task updated successfully');
          Navigator.pop(context);
        }

        if (state is TaskDeleted) {
          context.read<TasksCubit>().deleteTask(state.taskId);

          SnackBarUtils.success(context, 'Task deleted successfully');
          Navigator.pop(context);
        }

        if (state is TaskMutationError) {
          SnackBarUtils.error(context, state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is TaskMutationLoading;
        return Scaffold(
          appBar: AppBar(
            title: Text(
              isEditing ? 'Update Task' : 'New task',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            centerTitle: true,
            actions: [
              if (isEditing)
                IconButton(
                  onPressed: isLoading ? null : _deleteTask,
                  icon: const Icon(Icons.delete_outline),
                ),
              TextButton(
                onPressed: isLoading ? null : _saveTask,
                child: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(isEditing ? 'Update' : 'Save'),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Column(
                    spacing: 12,
                    children: [
                      TextFormField(
                        controller: titleController,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          hintText: 'Task title',
                        ),
                        validator: (value) {
                          return ValidatorUtils.required(
                            value,
                            fieldName: 'Title',
                          );
                        },
                      ),

                      TextFormField(
                        controller: descriptionController,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        minLines: 5,
                        maxLines: 10,
                        decoration: const InputDecoration(
                          hintText: 'Add a description...(Optional)',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Due date
                  NewTaskDatePickerWidget(
                    dueAt: dueAt,
                    onPressed: _pickDueDate,
                    onClear: () {
                      setState(() {
                        dueAt = null;
                      });
                    },
                  ),

                  const SizedBox(height: 28),

                  // Color
                  NewTaskColorPickerWidget(
                    selectedColor: selectedColor,
                    onColorSelected: (color) {
                      setState(() {
                        selectedColor = color;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
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

    if (!formKey.currentState!.validate()) {
      return;
    }

    if (dueAt == null) {
      SnackBarUtils.info(context, 'Please select a due date');
      return;
    }

    final now = DateTime.now();

    final updatedTask = task?.copyWith(
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      dueAt: dueAt!,
      color: selectedColor,
      updatedAt: now,
      isSynced: false,
    );

    final newTask = TaskModel(
      id: const Uuid().v4(),
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      createdAt: now,
      dueAt: dueAt!,
      color: selectedColor,
    );

    if (task != null) {
      context.read<TaskMutationCubit>().updateTask(updatedTask!);
    } else {
      context.read<TaskMutationCubit>().createTask(newTask);
    }
  }

  Future<void> _deleteTask() async {
    if (task == null) {
      return;
    }

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete task?'),
          content: const Text(
            'Are you sure you want to delete this task? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true || !mounted) {
      return;
    }
    FocusScope.of(context).unfocus();
    context.read<TaskMutationCubit>().deleteTask(task!.id);
  }
}
