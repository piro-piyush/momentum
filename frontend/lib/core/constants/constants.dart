export 'utils.dart';
export 'app_theme.dart';
export 'validator_utils.dart';
export 'app_routes.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static String get backendUri {
    return dotenv.env['BACKEND_URL'] ?? '';
  }
}