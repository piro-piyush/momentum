import 'package:momentum/lib.dart';

class TextFieldLabelWidget extends StatelessWidget {
  const TextFieldLabelWidget({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(label, style: Theme
        .of(context)
        .textTheme
        .labelLarge);
  }
}
