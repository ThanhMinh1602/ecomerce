import 'package:uuid/uuid.dart';

class AppUtils {
  static String generateId() {
    return const Uuid().v4().toUpperCase();
  }
}
