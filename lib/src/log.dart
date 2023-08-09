import 'package:flutter_smartlook/src/const_channels.dart';

class SmartlookLog {
  const SmartlookLog();

  /// Enables android logging to the console
  Future<void> enableLogging() async {
    await Channels.channel.invokeMethodOnMobile<void>('enableLogs');
  }
}
