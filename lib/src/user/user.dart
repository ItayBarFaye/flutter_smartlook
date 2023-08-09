import 'package:flutter_smartlook/src/const_channels.dart';
import 'package:flutter_smartlook/src/user/user_properties.dart';
import 'package:flutter_smartlook/src/user/user_session.dart';

/// A user's data contained in the record.
class SmartlookUser {
  const SmartlookUser();
  final UserSession session = const UserSession();
  final UserProperties properties = const UserProperties();

  /// Identifies current user - each user should have unique [identifier].
  Future<void> setIdentifier(String identifier) async {
    await Channels.channel.invokeMethodOnMobile<void>('setUserIdentifier', {
      "identifier": identifier,
    });
  }

  /// Sets a [name] of a current user
  Future<void> setName(String name) async {
    await Channels.channel.invokeMethodOnMobile<void>('setUserName', {"name": name});
  }

  /// Sets an [email] of a current user
  Future<void> setEmail(String email) async {
    await Channels.channel.invokeMethodOnMobile<void>('setUserEmail', {"email": email});
  }

  /// Closes old user and opens new one
  Future<void> openNew() async {
    await Channels.channel.invokeMethodOnMobile<void>('openNew');
  }

  /// Get user url for dashboard
  Future<String?> getUrl() async {
    final String? userUrl = await Channels.channel.invokeMethodOnMobile('getUserUrl');

    return userUrl;
  }
}
