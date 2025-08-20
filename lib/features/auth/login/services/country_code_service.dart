import 'dart:convert';
import 'dart:developer';

import 'package:country_picker/country_picker.dart';
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

  try {
    List<String> countryCodeList = [];
    
    // First try to get from your existing API
    final response = await http.get(Uri.parse(countryCodeUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      log('API Response: ${response.body}');
      
      for (var item in data['data']) {
        String? phoneCode;
        
        final possibleFields = [
          'phone_code',
          'dial_code',
          'calling_code',
          'country_code',
          'phonecode',
          'mobile_code',
          'international_code',
          'isd_code',
          'code'
        ];
        
        for (String field in possibleFields) {
          if (item[field] != null && item[field].toString().isNotEmpty) {
            phoneCode = item[field].toString();
            break;
          }
        }
        
        if (phoneCode != null) {
          if (!phoneCode.startsWith('+')) {
            phoneCode = '+$phoneCode';
          }
          countryCodeList.add(phoneCode);
        }
      }
      
      if (countryCodeList.isNotEmpty) {
        countryCodeList = countryCodeList.toSet().toList();
        _cachedCountryCodes = countryCodeList;
        log('Country codes from API: ${countryCodeList.length}');
        return countryCodeList;
      }
    }
    

    log('API failed, using country_picker package');
    final countries = CountryService().getAll();
    
    countryCodeList = countries
        .map((country) => '+${country.phoneCode}')
        .where((code) => code != '+' && code.length > 1)
        .toSet()
        .toList();
    
    countryCodeList.sort((a, b) {
      final aNum = int.tryParse(a.substring(1)) ?? 9999;
      final bNum = int.tryParse(b.substring(1)) ?? 9999;
      return aNum.compareTo(bNum);
    });
    
    _cachedCountryCodes = countryCodeList;
    log('Country codes from package: ${countryCodeList.length}');
    return countryCodeList;
    
  } catch (e) {
    log('Error: $e, using package fallback');
    
    // Final fallback using country_picker
    final countries = CountryService().getAll();
    final fallbackCodes = countries
        .map((country) => '+${country.phoneCode}')
        .where((code) => code != '+' && code.length > 1)
        .toSet()
        .toList();
    
    _cachedCountryCodes = fallbackCodes;
    return fallbackCodes;
  }
}

// Get country details by phone code
Country? getCountryByPhoneCode(String phoneCode) {
  final code = phoneCode.replaceAll('+', '');
  final countries = CountryService().getAll();
  
  try {
    return countries.firstWhere((country) => country.phoneCode == code);
  } catch (e) {
    return null;
  }
}

// Provider for country codes
final countryCodesProvider = FutureProvider<List<String>>((ref) async {
  return getCountryCode();
});