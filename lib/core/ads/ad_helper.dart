import 'package:flutter/foundation.dart';

class AdHelper {
  static bool get _useTestAds => kDebugMode;

  static String get bannerAdUnitId {
    if (_useTestAds) return 'ca-app-pub-3940256099942544/6300978111';
    return 'ca-app-pub-4723625213251350/8033670746';
  }

  static String get rewardedAdUnitId {
    if (_useTestAds) return 'ca-app-pub-3940256099942544/5224354917';
    return 'ca-app-pub-4723625213251350/1094414898';
  }
}
