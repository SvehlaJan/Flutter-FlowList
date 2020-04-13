import 'package:logger/logger.dart';

class FlowLogger {
  static Logger _instance;
  static bool _initialized = false;

  static void _initialize() {
    var printer = PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        printTime: false
    );
    _instance = Logger(printer: printer);
    _initialized = true;
  }

  static void _checkInitialized() {
    if (!_initialized) _initialize();
  }

  static void v(dynamic message, [dynamic error, StackTrace stackTrace]) {
    _checkInitialized();
    _instance.v(message, error, stackTrace);
  }

  static void d(dynamic message, [dynamic error, StackTrace stackTrace]) {
    _checkInitialized();
    _instance.d(message, error, stackTrace);
  }

  static void i(dynamic message, [dynamic error, StackTrace stackTrace]) {
    _checkInitialized();
    _instance.i(message, error, stackTrace);
  }

  static void w(dynamic message, [dynamic error, StackTrace stackTrace]) {
    _checkInitialized();
    _instance.w(message, error, stackTrace);
  }

  static void e(dynamic message, [dynamic error, StackTrace stackTrace]) {
    _checkInitialized();
    _instance.e(message, error, stackTrace);
  }

  static void wtf(dynamic message, [dynamic error, StackTrace stackTrace]) {
    _checkInitialized();
    _instance.wtf(message, error, stackTrace);
  }
}
