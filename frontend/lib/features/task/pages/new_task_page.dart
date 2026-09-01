import 'package:momentum/features/task/cubit/task_mutation/task_mutation_state.dart';
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

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New task',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        actions: [
          TextButton(onPressed: _saveTask, child: const Text('Save')),
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
                    decoration: const InputDecoration(hintText: 'Task title'),
                    validator: (value) {
                      return ValidatorUtils.required(value, fieldName: 'Title');
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
    final task = TaskModel(
      id: const Uuid().v4(),
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      createdAt: now,
      updatedAt: now,
      dueAt: dueAt!,
      color: selectedColor,
      isSynced: false,
    );

    // TODO: Save through TaskCubit.
    context.read<TaskMutationCubit>().createTask(task);

    SnackBarUtils.success(context, 'Task Saved');
    Navigator.pop(context);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
