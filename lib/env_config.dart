import 'dart:io';

/// If [SOFIE_API_HOST] is undefined then default to local.
class EnvironmentConfig {
  // dev:
  // http://localhost:4000/graphql ios and web
  // https://developer.android.com/studio/run/emulator-networking
  // http://10.0.2.2:4000/graphql android
  // Sandbox: https://spotme-api-sandbox.herokuapp.com/graphql
  // Staging: https://spotme-api-staging.herokuapp.com/graphql
  static String get localhost => Platform.isAndroid ? '10.0.2.2' : 'localhost';

  /// To be available via fromEnvironment() call
  /// NOTE: String.fromEnvironment() can only be invoked with const (also implicit, in const context) and never with "new".
  /// These env variables must be added to the codemagic build command via --dart-defines
  /// Do not add http:// to the start of the URL - this will cause an error when forming the uri below via [Uri.https]
  /// [spotme-api-staging.herokuapp.com]
  static String get apiHost => const bool.hasEnvironment('SOFIE_API_HOST')
      ? const String.fromEnvironment('SOFIE_API_HOST')
      : localhost;

  static String get graphqlEndpoint =>
      const bool.hasEnvironment('SOFIE_API_HOST')
          ? 'https://$apiHost/graphql'
          : 'http://$apiHost:4000/graphql';

  // Either from ENV or local (ios, web or android). Used for sign on + auth.
  static Uri getRestApiEndpoint(String endpoint,
      {Map<String, dynamic>? params}) {
    final url = 'api/$endpoint';

    return const bool.hasEnvironment('SOFIE_API_HOST')
        ? Uri.https(apiHost, url, params)
        // Use raw Uri due to host setting issues with other constructors
        : Uri(
            scheme: 'http',
            host: apiHost,
            port: 4000,
            path: url,
            queryParameters: params);
  }

  /// TODO: Not secure to be including private keys in dart defines?
  static String get uploadCarePublicKey =>
      const String.fromEnvironment('UPLOADCARE_PUBLIC_KEY');

  static String get uploadCarePrivateKey =>
      const String.fromEnvironment('UPLOADCARE_PRIVATE_KEY');

  static String get getStreamPublicKey =>
      const String.fromEnvironment('GETSTREAM_PUBLIC_KEY');

  static String get getStreamAppId =>
      const String.fromEnvironment('GETSTREAM_APP_ID');

  /// Platform specific layout
  static double get bottomNavBarHeight => Platform.isAndroid ? 62.0 : 82.0;
}
