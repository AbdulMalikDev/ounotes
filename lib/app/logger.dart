import 'package:logger/logger.dart';


class SimpleLogPrinter extends LogPrinter {
  final String className;
  SimpleLogPrinter(this.className);  

  @override
  void log(Level level, message, error, StackTrace stackTrace) {
    var color = PrettyPrinter.levelColors[level];
    var emoji = PrettyPrinter.levelEmojis[level];
    println(color('$emoji $className - $message'));
  }
}


Logger getLogger(String className) {
  return Logger(printer: SimpleLogPrinter(className));
}