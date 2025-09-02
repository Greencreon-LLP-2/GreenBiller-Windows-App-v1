import 'dart:convert';

import 'package:green_biller/core/constants/api_constants.dart';
import 'package:green_biller/features/packages/models/package_model.dart';
import 'package:http/http.dart' as http;

class PackageService {
  final String accessToken;
  PackageService({required this.accessToken});

  Future<PackageModel> viewPackageService() async {
    try {
      final reponse = await http.get(Uri.parse(viewPackageUrl),
          headers: {'Authorization': 'Bearer $accessToken'});
      final decodedResponse = jsonDecode(reponse.body);
      if (reponse.statusCode == 200) {
        return PackageModel.fromJson(decodedResponse);
      } else {
        return const PackageModel();
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
