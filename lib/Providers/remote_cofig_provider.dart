import 'package:flutter/material.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigProvider with ChangeNotifier {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  String _maskEmail = '';
  bool isMaskEmailFetched = false;
  String get maskEmail => _maskEmail;
  Future<void> fetchRemoteConfig() async {
    if (!isMaskEmailFetched)
      try {
        await _remoteConfig.setConfigSettings(RemoteConfigSettings(
          fetchTimeout: Duration(seconds: 30),
          minimumFetchInterval: Duration(hours: 1),
        ));
        await _remoteConfig.setDefaults(<String, dynamic>{
          'mask': '',
        });
        await _remoteConfig.fetchAndActivate();
        String mask = await _remoteConfig.getString('mask');

        _maskEmail = mask;

        print("got mail : $_maskEmail");
        isMaskEmailFetched = true;
        notifyListeners();
      } catch (e) {
        print("Remote Config fetch failed: $e");
      }
  }
}
