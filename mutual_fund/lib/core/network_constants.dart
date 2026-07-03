class NetworkConstants {
  static const String baseUrl = 'https://api.mfapi.in';

  static const String allSchemes = '$baseUrl/mf';

  static String schemeDetails(int schemeCode) => '$baseUrl/mf/$schemeCode';
}