import 'package:flutter/material.dart';

class SnackBarUtils {
  SnackBarUtils._();

  static void show(
      BuildContext context, {
        required String message,
        SnackBarType type = SnackBarType.error,
      }) {
    final messenger = ScaffoldMessenger.of(context);

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                _icon(type),
                color: Colors.white,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(message),
              ),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        ),
      );
  }

  static void success(
      BuildContext context,
      String message,
      ) {
    show(
      context,
      message: message,
      type: SnackBarType.success,
    );
  }

  static void error(
      BuildContext context,
      String message,
      ) {
    show(
      context,
      message: message,
      type: SnackBarType.error,
    );
  }

  static void info(
      BuildContext context,
      String message,
      ) {
    show(
      context,
      message: message,
      type: SnackBarType.info,
    );
  }

  static IconData _icon(SnackBarType type) {
    return switch (type) {
      SnackBarType.success => Icons.check_circle_outline_rounded,
      SnackBarType.error => Icons.error_outline_rounded,
      SnackBarType.info => Icons.info_outline_rounded,
    };
  }
}

enum SnackBarType {
  success,
  error,
  info,
}