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
import 'package:device_preview_screenshot/device_preview_screenshot.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:path_provider/path_provider.dart';

// Project imports:
import 'package:budgetme/src/config/constants.dart';
import 'package:budgetme/src/config/device_preview_screenshot_helper.dart';
import 'package:budgetme/src/config/themes/dark_theme/dark_theme.dart';
import 'package:budgetme/src/config/themes/light_theme/light_theme.dart';
import 'package:budgetme/src/lang/budgetme_localizations.dart';
import 'package:budgetme/src/providers/balance_repository_provider.dart';
import 'package:budgetme/src/providers/goal_repository_provider.dart';
import 'package:budgetme/src/providers/notification_service_provider.dart';
import 'package:budgetme/src/providers/pro_user_repository_provider.dart';
import 'package:budgetme/src/providers/theme_provider.dart';
import 'package:budgetme/src/repositories/pro_user_repository.dart';
import 'package:budgetme/src/services/notification_service.dart';
import 'package:budgetme/src/ui/components/show_purchase_pro_bottom_sheet.dart';
import 'package:budgetme/src/ui/views/dashboard_view/dashboard_view.dart';

final bmNavigatorKey = GlobalKey<NavigatorState>();

void main() async {
  /// Catches all occuring errors in app
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp();

    /// Initiate Hive local DB.
    await Hive.initFlutter();
    await Hive.openBox('budgetme');

    if (!kReleaseMode) {
      // await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    } else {
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    }

    /// Lock device orientation to portrait
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    final localDir = await getApplicationDocumentsDirectory();
    generalGoalImagePath = localDir.path;

    /// Device Preview makes it easier to do the store screenshots
    /// process.
    ///
    /// Set `enabled: !kReleaseMode => enabled: false` if you want to
    /// remove the toolbar and use the app regularly
    runApp(
      DevicePreview(
        enabled: !kReleaseMode, // This line
        devices: screenshotDevices,
        availableLocales: supportedLocales,
        tools: const [
          DeviceSection(),
          SystemSection(),
          DevicePreviewScreenshot(onScreenshot: onScreenshot, multipleScreenshots: true),
        ],
        builder: (context) {
          return Phoenix(child: const ProviderScope(child: BudgetMe()));
        },
      ),
    );

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
  /// IAP Plugin Interface
  final _iap = InAppPurchase.instance;

  /// Updates to purchases
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  /// Past purchases
  List<PurchaseDetails> _purchaseDetails = [];

  /// Is the API available on the device
  bool _available = true;

  /// Pro User
  bool proUser = ProUserRepository().proUser;

  @override
  void initState() {
    super.initState();

    _loadData();

    final proUser = ref.read(proUserRepositoryProvider).proUser;

    if (!proUser) {
      _startAdMob();
    }

    _startIAP();
    _startNotifications();
  }

  void _loadData() async {
    ref.read(proUserRepositoryProvider).loadData();
    ref.read(goalRepositoryProvider.notifier).loadData();
    await ref.read(balanceRepositoryProvider).loadData();
  }

  void _startNotifications() async {
    await NotificationService.init(initScheduled: true);
    await ref.read(notificationServiceProvider).showScheduledNotification();
  }

  void _startIAP() async {
    _available = await _iap.isAvailable();

    if (_available) {
      _subscription = _iap.purchaseStream.listen((data) {
        if (mounted) {
          setState(() {
            _purchaseDetails = data;
          });
        }

        _listenToPurchaseUpdated(data);
      }, onDone: () {
        _subscription.cancel();
      }, onError: (error) {
        FirebaseCrashlytics.instance.recordError(error, null);
      });
    }
  }

  void _startAdMob() {
    MobileAds.instance.initialize();
    if (!kReleaseMode) {
      MobileAds.instance
          .updateRequestConfiguration(RequestConfiguration(testDeviceIds: ['24dd1932493cb289284c0d8588b2077b']));
    }
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.error) {
        FirebaseCrashlytics.instance.recordError(purchaseDetails.error, null);
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        _verifyPurchase();
        ref.read(proUserRepositoryProvider).setProUser();
        Phoenix.rebirth(context);
      } else if (purchaseDetails.pendingCompletePurchase) {
        await _iap.completePurchase(purchaseDetails);
      }
    }
  }

  PurchaseDetails _hasPurchased(String productId) {
    return _purchaseDetails.firstWhere((element) => element.productID == productId);
  }

  void _verifyPurchase() {
    PurchaseDetails purchase = _hasPurchased(budgetmeProID);

    if (purchase.status == PurchaseStatus.purchased) {
      proUser = true;
    }
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
          useInheritedMediaQuery: !kReleaseMode,
          debugShowCheckedModeBanner: false,
          title: kAppTitle,
          themeMode: repo.themeMode,
          theme: lightTheme(),
          darkTheme: darkTheme(),
          home: const DashboardView(),
          localizationsDelegates: BudgetMeLocalizations.localizationsDelegates,
          supportedLocales: supportedLocales,
          builder: DevicePreview.appBuilder,
        );
      },
    );
  }
}
