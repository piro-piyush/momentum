import 'package:momentum/lib.dart';

class NewTaskColorPickerWidget extends StatelessWidget {
  const NewTaskColorPickerWidget({
    super.key,
    // required this.colors,
    required this.selectedColor,
    required this.onColorSelected,
  });

  // final List<Color> colors;
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ColorPicker(
      padding: EdgeInsetsGeometry.zero,
      heading: Text(
        'Select color',
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      subheading: Text(
        'Select a diff shade Color',
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      onColorChanged: onColorSelected,
      color: selectedColor,
      // pickersEnabled: {ColorPickerType.wheel: true},
    );
  }
}
