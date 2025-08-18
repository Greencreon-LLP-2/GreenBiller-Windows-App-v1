import 'dart:convert';
import 'dart:developer';

import 'package:green_biller/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;

// const String tokenn = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIwMTk2ZTc1OS04YzYwLTcxZDgtYWIyNS1lYTM3NmMwOTMyMzEiLCJqdGkiOiJlOWE2Y2Y1N2E2OWQxMGU4Mzg3M2I5OTYxNGVhOTJjYjMwMTdiYTc5MjFmMjJiNDhhOWQzZjFhYTNjNjJiMTlkZjY5ZjVhOTE0NWFiZjQ4OSIsImlhdCI6MTc0NzcxMzEwNi4xMjc1MjYsIm5iZiI6MTc0NzcxMzEwNi4xMjc1MjgsImV4cCI6MTc2MzYxMDcwNi4xMjM5MzQsInN1YiI6IjEyIiwic2NvcGVzIjpbXX0.e3ucOMHZpnwVCmqRxL5TCnyod-1t3l_H3Os-wglnm0zFP-9a5hO7qvJdmbc-HgtOmojSohHq2tF0ygFgEVmtcBLb5iQEAsRTChsYsxW5LPruDVysDhET4BKlYprlSALmAjb8l7uKvzF0jSKqVMu0lMHz92xe4sdx3p_ct9ByDtPzi-X5nOwyCC2SAfWRuvElnemmkaEMRWFHANsDOwUJSzZntAUbhiSA_Mn0Tz7mP9fjty-2cGhM7YgvVm2cPiIyRvyvYDl6J_D6PhSEisWwfmYaMOxByNsdQjQCvVIjlp6gzfLZAwwXImPDzcLHHgZX1TU7IG3Fr-TRzkcDyqH49qw5BMHbC07mYo1bN2EalMnVZb9Q8fZ4vl1Jz_GGPO8WRqIusqVp-P4DmanGVb2eLrrWCbbLhzK33jsaF5NxlMrXHxSbkLlodHWKf2QSkJmMH6VO35KLtu4kon53iOByQN-0BSi5AflxVsGmEWfU1MUrLyMeoJX5oajN9qPV6mn87bYU6cPaDxEXg6PCtPD4HqVGO2f6hOrayi1F6kKduyMNZYBxLIpqhuEJ8DyCDsaLz_67gWDt3lFQ1FhPCOpksZHpBOya7VcDe25HVxjbb0t9nO06TI5ErWRHaov_AzDxQM7oEKiX1FUkIRhovumY83HKanSMXca0BQal2UtPOKg";

Future<String> addWarehouseService(
  String name,
  String adress,
  String warehouseType,
  String mobile,
  String email,
  String accessToken,
  String? storeId,
  String? userId,
) async {
  try {
    final response = await http.post(
      Uri.parse(addWarehouseUrl),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
      body: {
        'warehouse_name': name,
        'address': adress,
        'warehouse_type': warehouseType,
        "mobile": mobile,
        "email": email,
        "store_id": storeId,
        "user_id": userId
      },
    );
    // log(response.body);
    final decodedata = jsonDecode(response.body);
    if (response.statusCode == 201) {
      log('${decodedata["message"]}');
      return decodedata['message'];
    } else {
      throw Exception('Failed to add warehouse: ${decodedata["message"]}');
    }
  } catch (e) {
    throw Exception('Failed to add warehouse: $e');
  }
}
