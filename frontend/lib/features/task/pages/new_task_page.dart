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

  // Color selectedColor = Colors.blue;
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
      // selectedColor = argument.color;
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
          SnackBarUtils.error(
            context,
            ApiService.getApiErrorMessage(state.message, state.details),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is TaskMutationLoading;
        final theme = Theme.of(context);

        final isDark = theme.brightness == Brightness.dark;

        final backgroundColor = isDark
            ? const Color(0xFF0A0A0A)
            : const Color(0xFFF8F8F8);

        final fieldColor = isDark ? const Color(0xFF141414) : Colors.white;

        final foregroundColor = isDark ? Colors.white : const Color(0xFF111111);

        final mutedColor = isDark
            ? const Color(0xFF9A9A9A)
            : const Color(0xFF6B6B6B);

        final borderColor = isDark
            ? const Color(0xFF292929)
            : const Color(0xFFE5E5E5);
        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: backgroundColor,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            title: Text(
              isEditing ? 'Update Task' : 'New Task',
              style: TextStyle(
                color: foregroundColor,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              onPressed: isLoading ? null : () => Navigator.pop(context),
              icon: Icon(Icons.close_rounded, color: foregroundColor),
            ),
            actions: [
              if (isEditing)
                IconButton(
                  onPressed: isLoading ? null : _deleteTask,
                  tooltip: 'Delete task',
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: foregroundColor,
                  ),
                ),

              const SizedBox(width: 4),

              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: FilledButton(
                  onPressed: () {
                    isLoading ? null : _saveTask();
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: foregroundColor,
                    foregroundColor: isDark ? Colors.black : Colors.white,
                    disabledBackgroundColor: foregroundColor.withValues(
                      alpha: 0.4,
                    ),
                    disabledForegroundColor: isDark
                        ? Colors.black54
                        : Colors.white70,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    minimumSize: const Size(0, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? SizedBox(
                          width: 17,
                          height: 17,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: isDark ? Colors.black : Colors.white,
                          ),
                        )
                      : Text(
                          isEditing ? 'Update' : 'Save',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                ),
              ),
            ],
          ),

          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ------------------------------------------------------------
                  // Task details
                  // ------------------------------------------------------------

                  Text(
                    'TASK DETAILS',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: mutedColor,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    decoration: BoxDecoration(
                      color: fieldColor,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: borderColor),
                      boxShadow: [
                        if (!isDark)
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.035),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                      ],
                    ),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: titleController,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(
                            color: foregroundColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          cursorColor: foregroundColor,
                          decoration: InputDecoration(
                            hintText: 'Task title',
                            hintStyle: TextStyle(
                              color: mutedColor,
                              fontWeight: FontWeight.w500,
                            ),
                            prefixIcon: Icon(
                              Icons.check_circle_outline_rounded,
                              color: mutedColor,
                              size: 21,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 18,
                            ),
                          ),
                          validator: (value) {
                            return ValidatorUtils.required(
                              value,
                              fieldName: 'Title',
                            );
                          },
                        ),

                        Divider(
                          height: 1,
                          indent: 18,
                          endIndent: 18,
                          color: borderColor,
                        ),

                        TextFormField(
                          controller: descriptionController,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          minLines: 5,
                          maxLines: 10,
                          style: TextStyle(
                            color: foregroundColor,
                            fontSize: 15,
                            height: 1.5,
                          ),
                          cursorColor: foregroundColor,
                          decoration: InputDecoration(
                            hintText: 'Add a description... (Optional)',
                            hintStyle: TextStyle(
                              color: mutedColor,
                              fontWeight: FontWeight.w400,
                            ),
                            // prefixIcon: Padding(
                            //   padding: const EdgeInsets.only(
                            //     left: 18,
                            //     right: 10,
                            //     top: 18,
                            //   ),
                            //   child: Icon(
                            //     Icons.notes_rounded,
                            //     color: mutedColor,
                            //     size: 21,
                            //   ),
                            // ),
                            prefixIconConstraints: const BoxConstraints(
                              minWidth: 0,
                              minHeight: 0,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.fromLTRB(
                              18,
                              18,
                              18,
                              18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ------------------------------------------------------------
                  // Due date
                  // ------------------------------------------------------------
                  ScheduleDatePickerWidget(
                    onPressed: _pickDueDate,
                    dueAt: dueAt,
                    onClear: () {
                      setState(() {
                        dueAt = null;
                      });
                    },
                  ),
                  const SizedBox(height: 28),

                  // ------------------------------------------------------------
                  // Color
                  // ------------------------------------------------------------
                  // Text(
                  //   'APPEARANCE',
                  //   style: theme.textTheme.labelSmall?.copyWith(
                  //     color: mutedColor,
                  //     fontWeight: FontWeight.w700,
                  //     letterSpacing: 1.2,
                  //   ),
                  // ),
                  //
                  // const SizedBox(height: 10),
                  //
                  // NewTaskColorPickerWidget(
                  //   selectedColor: selectedColor,
                  //   onColorSelected: (color) {
                  //     setState(() {
                  //       selectedColor = color;
                  //     });
                  //   },
                  // ),
                  //
                  // const SizedBox(height: 20),
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
      // color: selectedColor,
      updatedAt: now,
      isSynced: false,
      isDeleted: false,
    );

    final newTask = TaskModel(
      id: const Uuid().v4(),
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      createdAt: now,
      dueAt: dueAt!,
      // color: selectedColor,
      isSynced: false,
      isDeleted: false,
      isNew: true,
    );

    if (task != null) {
      context.read<TaskMutationCubit>().updateTask(updatedTask!);
    } else {
      context.read<TaskMutationCubit>().createTask(newTask);
    }
  }

  Future<void> _deleteTask() async {
    final currentTask = task;

    if (currentTask == null) {
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

    await context.read<TaskMutationCubit>().deleteTask(currentTask);
  }
}
