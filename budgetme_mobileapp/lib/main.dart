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

// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

// Project imports:
import 'package:budgetme/src/config/constants.dart';
import 'package:budgetme/src/config/themes/dark_theme/dark_theme.dart';
import 'package:budgetme/src/config/themes/light_theme/light_theme.dart';
import 'package:budgetme/src/lang/budgetme_localizations.dart';
import 'package:budgetme/src/providers/balance_repository_provider.dart';
import 'package:budgetme/src/providers/goal_repository_provider.dart';
import 'package:budgetme/src/providers/notification_service_provider.dart';
import 'package:budgetme/src/providers/theme_provider.dart';
import 'package:budgetme/src/services/notification_service.dart';
import 'package:budgetme/src/ui/views/dashboard_view/dashboard_view.dart';

void main() async {
  /// Catches all occuring errors in app
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp();

    /// Initiate Hive local DB.
    await Hive.initFlutter();
    await Hive.openBox('budgetme');

    if (kDebugMode) {
      // await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    } else {
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    }

    /// Lock device orientation to portrait
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    final localDir = await getApplicationDocumentsDirectory();
    generalGoalImagePath = localDir.path;

    runApp(const ProviderScope(child: BudgetMe()));

    /// Sends all caught errors to firebase.
  }, (error, stack) async {
    await FirebaseCrashlytics.instance.recordError(error, stack);
  });
}

class BudgetMe extends ConsumerStatefulWidget {
  const BudgetMe({Key? key}) : super(key: key);

  @override
  ConsumerState<BudgetMe> createState() => _BudgetMeState();
}

class _BudgetMeState extends ConsumerState<BudgetMe> {
  @override
  void initState() {
    super.initState();
    _loadData();
    _startNotifications();
  }

  void _loadData() async {
    ref.read(goalRepositoryProvider.notifier).loadData();
    await ref.read(balanceRepositoryProvider).loadData();
  }

  void _startNotifications() async {
    await NotificationService.init(initScheduled: true);
    await ref.read(notificationServiceProvider).showScheduledNotification();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(428, 926),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        final repo = ref.watch(themeProvider);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: kAppTitle,
          themeMode: repo.themeMode,
          theme: lightTheme(),
          darkTheme: darkTheme(),
          home: const DashboardView(),
          localizationsDelegates: BudgetMeLocalizations.localizationsDelegates,
          supportedLocales: [
            Locale('en', ''),
            Locale('es', ''),
            Locale('ja', ''),
            Locale('ko', ''),
            Locale('ru', ''),
            Locale('zh', ''),
            Locale('ar', ''),
            Locale('pt', ''),
            Locale('fr', ''),
            Locale('de', ''),
            Locale('he', ''),
          ],
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: GestureDetector(
                onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                child: Navigator(
                  observers: [FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)],
                  onGenerateRoute: (settings) {
                    return MaterialPageRoute(
                      settings: settings,
                      builder: (context) {
                        return child!;
                      },
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
