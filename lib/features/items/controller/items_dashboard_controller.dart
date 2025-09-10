import 'dart:convert';
import 'package:get/get.dart';
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';
import 'package:greenbiller/features/items/model/items_insights_model.dart';
import 'package:logger/logger.dart';

class ItemsDashboardController extends GetxController {
  // Dependencies
  final DioClient dioClient = DioClient();

  ItemsDashboardController();

  // State
  var isLoading = false.obs;
  var totalItems = 0.obs;
  var totalCategories = 0.obs;
  var totalBrands = 0.obs;
  var totalUnits = 0.obs;

  var units = <InsightsUnits>[].obs;
  var categories = <InsightsCategory>[].obs;
  var brands = <InsightsBrand>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;

      final response = await dioClient.dio.get("$baseUrl/item-dashboard");

      if (response.statusCode == 200 && response.data['status'] == true) {
        final data = response.data;

        totalItems.value = data['totalitem'] ?? 0;
        totalCategories.value = data['totalcategory'] ?? 0;
        totalBrands.value = data['totalbrand'] ?? 0;
        totalUnits.value = data['totalunit'] ?? 0;

        units.assignAll(
          (data['units'] as List<dynamic>?)
                  ?.map((e) => InsightsUnits.fromJson(e))
                  .toList() ??
              [],
        );
        categories.assignAll(
          (data['categories'] as List<dynamic>?)
                  ?.map((e) => InsightsCategory.fromJson(e))
                  .toList() ??
              [],
        );
        brands.assignAll(
          (data['brands'] as List<dynamic>?)
                  ?.map((e) => InsightsBrand.fromJson(e))
                  .toList() ??
              [],
        );
      } else {
        Get.snackbar("Error", "Unable to load dashboard data");
      }
    } catch (e, stack) {
      Get.snackbar(
        "Error",
        "Something went wrong while fetching dashboard data",
      );
      Logger().e("Error fetching dashboard data: $e\n$stack");
    } finally {
      isLoading.value = false;
    }
  }
}
