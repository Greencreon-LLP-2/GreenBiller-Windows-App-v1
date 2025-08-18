import 'package:green_biller/features/packages/models/package_model.dart';
import 'package:green_biller/features/packages/service/package_service.dart';

class ViewPackageController {
  final String accessToken;
  ViewPackageController({required this.accessToken});

  Future<PackageModel> viewPackageController() async {
    try {
      final response =
          await PackageService(accessToken: accessToken).viewPackageService();
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }
}
