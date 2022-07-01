import 'package:budgetme/src/config/environment_keys.dart';
import 'package:unsplash_client/unsplash_client.dart';

class UnsplashService {
  UnsplashService();

  final unsplashClient = UnsplashClient(
    settings: const ClientSettings(
      credentials: AppCredentials(
        accessKey: unsplashServiceAccessKey,
        secretKey: unsplashServiceSecretKey,
      ),
    ),
  );

  UnsplashClient get client => unsplashClient;
}
