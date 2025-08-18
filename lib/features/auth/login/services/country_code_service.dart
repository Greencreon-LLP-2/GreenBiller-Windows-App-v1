import 'dart:convert';
import 'dart:developer';

import 'package:green_biller/core/constants/api_constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

// Cache for country codes
List<String>? _cachedCountryCodes;

Future<List<String>> getCountryCode() async {
  // Return cached codes if available
  if (_cachedCountryCodes != null) {
    return _cachedCountryCodes!;
  }

  List<String> countryCodeList = [];
  final response = await http.get(Uri.parse(countryCodeUrl));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    for (var item in data['data']) {
      countryCodeList.add(item['currency_code']);
    }
    // Cache the results
    _cachedCountryCodes = countryCodeList;
    log(countryCodeList.toString());
    return countryCodeList;
  } else {
    throw Exception('Failed to load country code');
  }
}

// Provider for country codes
final countryCodesProvider = FutureProvider<List<String>>((ref) async {
  return getCountryCode();
});
