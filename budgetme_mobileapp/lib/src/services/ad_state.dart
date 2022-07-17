/*
BudgetMe iOS & Android App
Copyright (C) 2022 Carlton Aikins

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

import 'dart:io';

class AdState {
  // iOS ad ids
  static const _iosAddMoneyInterstitialAdId =
      'ca-app-pub-3940256099942544/4411468910' /*'ca-app-pub-6026970342993334/3051582203'*/;
  static const _iosCreateEditInterstitialAdId = 'ca-app-pub-6026970342993334/2175013605';

  // Android ad ids
  static const _androidAddMoneyInterstitialAdId = 'ca-app-pub-6026970342993334/9576929275';
  static const _androidCreateEditInterstitialAdId = 'ca-app-pub-6026970342993334/1930636874';

  String get addMoneyInterstitialAdUnitId {
    if (Platform.isAndroid) {
      return _androidAddMoneyInterstitialAdId;
    } else {
      return _iosAddMoneyInterstitialAdId;
    }
  }

  String get createEditInterstitialAdUnitId {
    if (Platform.isAndroid) {
      return _androidCreateEditInterstitialAdId;
    } else {
      return _iosCreateEditInterstitialAdId;
    }
  }
}
