import 'package:logger/logger.dart';

class Log {
  static var logger = Logger(printer: PrettyPrinter(methodCount: 0, errorMethodCount: 1));

  static void e(String message) {
    logger.e(message);
  }

  static void i(String message) {
    logger.i(message);
  }

  static void d(String message) {
    logger.d(message);
  }

  static void w(String message) {
    logger.w(message);
  }
}
