import 'package:green_biller/features/item/model/unit/unit_model.dart';
import 'package:green_biller/features/item/services/unit/view_unit_service.dart';

class UnitController {
  final String accessToken;
  UnitController({required this.accessToken});

  Future<UnitModel> getUnitData() async {
    try {
      final viewUnitService = ViewUnitService(accessToken: accessToken);
      final response = await viewUnitService.viewUnit();
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }
}
