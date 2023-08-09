import 'package:flutter_smartlook/src/const_channels.dart';

/// Current recording session
class UserSession {
  const UserSession();

  /// Closes old session and opens new one
  Future<void> openNew() async {
    await Channels.channel.invokeMethodOnMobile<void>('openNewSession');
  }

  /// Gets session url
  Future<String?> getUrl() async {
    final String? sessionUrl =
        await Channels.channel.invokeMethodOnMobile('getSessionUrl');

    return sessionUrl;
  }

  /// Gets session url with Timestamp
  Future<String?> getUrlWithTimeStamp() async {
    final String? sessionUrlWithTimestamp =
        await Channels.channel.invokeMethodOnMobile('getSessionUrlWithTimeStamp');

    return sessionUrlWithTimestamp;
  }
}
