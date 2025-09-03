import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';
import 'package:greenbiller/core/utils/common_api_functions_controller.dart';
import 'package:greenbiller/features/auth/controller/auth_controller.dart';

class AdminStoreController extends GetxController {
  late CommonApiFunctionsController commonApi;
  late AuthController authController;
  late DioClient dioClient;

  final tabController = TabController(length: 2, vsync: NavigatorState());
  final currentTabIndex = 0.obs;
  final warehouseNameController = TextEditingController();
  final warehouseTypeController = TextEditingController();
  final warehouseAddressController = TextEditingController();
  final warehouseEmailController = TextEditingController();
  final warehousePhoneController = TextEditingController();
  final RxInt userId = 0.obs;
  @override
  void onInit() {
    super.onInit();
    dioClient = DioClient();
    commonApi = CommonApiFunctionsController();
    authController = Get.find<AuthController>();
    userId.value = authController.user.value?.userId ?? 0;
    
    tabController.addListener(() {
      currentTabIndex.value = tabController.index;
    });
  }

  @override
  void onClose() {
    tabController.dispose();
    warehouseNameController.dispose();
    warehouseTypeController.dispose();
    warehouseAddressController.dispose();
    warehouseEmailController.dispose();
    warehousePhoneController.dispose();
    super.onClose();
  }
}
