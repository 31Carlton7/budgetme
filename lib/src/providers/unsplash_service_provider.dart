import 'package:budgetme/src/services/unsplash_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final unsplashServiceProvider = Provider<UnsplashService>((ref) {
  return UnsplashService();
});
