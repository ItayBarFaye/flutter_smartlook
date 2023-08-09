import 'package:flutter_smartlook/src/const_channels.dart';

/// [Region] is a place where the data are stored
enum Region
{
  /// Default region
  EU,

  /// US region
  US,
}

/// Additional configurations.
class SmartlookSetupConfiguration {


  const SmartlookSetupConfiguration();
  /// Gets custom region for storing data
  Future<Region?> getRegion() async {
   final int? region = await Channels.channel.invokeMethodOnMobile<int?>('getRegion');

   return region == null ? null : Region.values[region];

  }


  /// Sets custom region for storing data
  Future<void> setRegion(Region region) async {
    await Channels.channel.invokeMethodOnMobile<void>('setRegion', {
      "region": region.index,
    });
  }
}
