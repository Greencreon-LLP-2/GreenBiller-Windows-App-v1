import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';
import 'package:greenbiller/core/app_handler/hive_service.dart';

import 'package:greenbiller/features/auth/controller/auth_controller.dart';
import 'package:greenbiller/features/settings/models/business_profile_model.dart';

import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

class BusinessProfileController extends GetxController {
  final DioClient dioClient = Get.find<DioClient>();
  final AuthController authController = Get.find<AuthController>();
  final HiveService hiveService = Get.find<HiveService>();
  final Logger logger = Logger();
  final ImagePicker picker = ImagePicker();

  // Form key
  final formKey = GlobalKey<FormState>();

  // Text controllers
  final businessNameController = TextEditingController();
  final mobileController = TextEditingController();
  final tinController = TextEditingController();
  final emailController = TextEditingController();
  final gstController = TextEditingController();
  final pincodeController = TextEditingController();
  final addressController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Form fields
  final name = ''.obs;
  final phone = ''.obs;
  final tin = ''.obs;
  final email = ''.obs;
  final gst = ''.obs;
  final pincode = ''.obs;
  final address = ''.obs;
  final businessType = Rxn<String>();
  final category = Rxn<String>();
  final state = Rxn<String>();
  final logoImage = Rxn<XFile>();
  final signatureImage = Rxn<XFile>();
  final logoImageFile = ''.obs;
  final signatureImageFile = ''.obs;
  final currentPassword = ''.obs;
  final newPassword = ''.obs;
  final confirmPassword = ''.obs;

  // State
  final isLoading = true.obs;
  final isSaving = false.obs;
  final hasChanges = false.obs;
  final showPasswordModal = false.obs;
  final showCurrentPassword = false.obs;
  final showNewPassword = false.obs;
  final showConfirmPassword = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadBusinessProfile();
    // Setup change listeners

    // dioClient.setAuthToken(
    //   "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIwMTk3NDQ0OS04NmEwLTcxMjEtODk2NC0yMjUzODNiZmU0MzUiLCJqdGkiOiI3OGIwZDc0NzU2MDZiM2Q3YzNlNTQ1OTMxZDlmMGMzOTFlOTM1Y2ZjZDUxNzZkODdmNjEyZmQwYzg0YWQyNzA3MWFlOTY2ODQwZmY4ZDRlMyIsImlhdCI6MTc1NjcyMDIzMS40NjY5NDYsIm5iZiI6MTc1NjcyMDIzMS40NjY5NTIsImV4cCI6MTc3MjM1ODYzMS40MTMzNDQsInN1YiI6IjYyIiwic2NvcGVzIjpbXX0.ZVMeK8uZKSU9_jbgm39gp2ai6fAarKYV-0Qh9XzGga3_ybnA-z63Q6R3w1MCPKi8k41f-BxYDXMR-uEvvOW-umbPhW0mzB5XeQbskzabIbfVSI-_-anCxzV3Z8KQWY1UAH-_P8X1NvPWGpQALuBQeZ7cwqbFOAhVwCTguwBTdrUp8YxlMldRtje2EzH1q2l-tx68mah-Wgv-Te7LZCNzDSIXH9hMuU5H17l3DoM5KV0Hi5xR8lpD7y3WSjMVhOSmw68kDQinFNzYtEeLGQs3BH5KWuDkJdr-oyB4Jgb6HIN_UzGvcnhwqZ-VQXfj3L6hNjOXPuTEyIq1Ovj81lr6fkdscWX0x6BEY9MpsN_pBPh6DzBRq8_g4wQjg8GcEbt0EDhW7Gh0hzeX5Gb1yiB_QNyD3fqYkSfxVpXdRM2whMoEELYwTtME03ONfeQyDH5UEUyhsn2OvAg27L1v6ZgbwRHCiMagPBS3xRpQ0rEFHHizf3lonIrbBth2bYXpmC0tVoI45v0aOICBuicHNkAFHAcV-dMRDydXRe5kqC1jNfteFmB00CqDla0DhUhEuhyFnn-A6vT62QC2b_sIAmQdeIv4RbAueQ_4oYh798PyK7-1hwFnh37BN67E3bqmqdylyoz1ocHUM0QRVijeui0ucV5yqMzaUxz2_gHdBGAmSI8",
    // );
    final fields = <RxInterface>[
      name,
      phone,
      tin,
      email,
      gst,
      pincode,
      address,
      businessType,
      category,
      state,
      logoImage,
      signatureImage,
    ];

    for (final obs in fields) {
      ever(obs, (_) => hasChanges.value = true);
    }

    // Sync controllers with Rx values
    businessNameController.text = name.value;
    mobileController.text = phone.value;
    tinController.text = tin.value;
    emailController.text = email.value;
    gstController.text = gst.value;
    pincodeController.text = pincode.value;
    addressController.text = address.value;
  }

  Future<void> loadBusinessProfile() async {
    try {
      isLoading.value = true;

      final response = await dioClient.dio.get(businessProfileViewUrl);

      if (response.statusCode == 200) {
        logger.i('Profile API response: ${response.data}');
        final data = response.data['data'];

        if (data == null || (data is List && data.isEmpty)) {
          logger.w('No business profile found, user must create one.');
          // clear hive since no profile exists
          await hiveService.clearBusinessProfile();
        } else {
          // Handle List response correctly
          final Map<String, dynamic> profileJson = data is List
              ? Map<String, dynamic>.from(data.first)
              : Map<String, dynamic>.from(data);

          final profile = BusinessProfile.fromJson(profileJson);

          // assign reactive values
          name.value = profile.name;
          phone.value = profile.phone;
          tin.value = profile.tin ?? '';
          email.value = profile.email ?? '';
          gst.value = profile.gst ?? '';
          pincode.value = profile.pincode ?? '';
          address.value = profile.address ?? '';
          businessType.value = profile.businessType;
          category.value = profile.category;
          state.value = profile.state;

          if (profile.profileImagePath != null) {
            logoImageFile.value = "$publicUrl/${profile.profileImagePath!}";
          }
          if (profile.signatureImagePath != null) {
            signatureImageFile.value =
                "$publicUrl/${profile.signatureImagePath!}";
          }

          // Update text controllers
          businessNameController.text = name.value;
          mobileController.text = phone.value;
          tinController.text = tin.value;
          emailController.text = email.value;
          gstController.text = gst.value;
          pincodeController.text = pincode.value;
          addressController.text = address.value;

          // Save to Hive for offline + mark profile as existing
          await hiveService.saveBusinessProfile(profile);
          logger.i('Loaded business profile: ${profile.name}');
        }
      } else {
        logger.w('Failed to load profile: ${response.data}');
        Get.snackbar(
          'Error',
          'Failed to load profile',
          backgroundColor: Colors.red,
        );
      }
    } catch (e, stackTrace) {
      logger.e('Error loading business profile: $e', e, stackTrace);
      Get.snackbar(
        'Error',
        'Error loading profile: $e',
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
      hasChanges.value = false;
    }
  }

  Future<Map<String, dynamic>> _createOrUpdateProfile({
    required Map<String, dynamic> data,
    XFile? profileImage,
    XFile? signatureImage,
    bool isUpdate = false,
    String? profileId,
  }) async {
    try {
      final formData = dio.FormData.fromMap(data);
      if (profileImage != null) {
        formData.files.add(
          MapEntry(
            'profileImagePath',
            await dio.MultipartFile.fromFile(
              profileImage.path,
              filename: profileImage.path.split('/').last,
            ),
          ),
        );
      }
      if (signatureImage != null) {
        formData.files.add(
          MapEntry(
            'signatureImagePath',
            await dio.MultipartFile.fromFile(
              signatureImage.path,
              filename: signatureImage.path.split('/').last,
            ),
          ),
        );
      }
      final url = isUpdate
          ? '$businessProfileEditUrl/$profileId'
          : businessProfileCreateUrl;
      final response = await dioClient.dio.request(
        url,
        data: formData,
        options: dio.Options(
          method: isUpdate ? 'PUT' : 'POST',
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );
      if (response.statusCode == 200 && response.data['status'] == 1) {
        return response.data;
      } else {
        throw Exception(
          response.data['message'] ??
              'Failed to ${isUpdate ? "update" : "create"} profile',
        );
      }
    } catch (e, stackTrace) {
      logger.e(
        'Error ${isUpdate ? "updating" : "creating"} business profile: $e',
        e,
        stackTrace,
      );
      throw Exception(
        'Error ${isUpdate ? "updating" : "creating"} business profile: $e',
      );
    }
  }

  Future<void> saveProfile() async {
    if (!formKey.currentState!.validate()) {
      Get.snackbar(
        'Error',
        'Please fill all required fields',
        backgroundColor: Colors.red,
      );
      return;
    }
    try {
      isSaving.value = true;
      final data = {
        'business_name': name.value.trim(),
        'mobile': phone.value.trim(),
        if (tin.value.isNotEmpty) 'tin': tin.value.trim(),
        if (email.value.isNotEmpty) 'email': email.value.trim(),
        if (gst.value.isNotEmpty) 'gst': gst.value.trim(),
        if (pincode.value.isNotEmpty) 'pincode': pincode.value.trim(),
        if (address.value.isNotEmpty) 'address': address.value.trim(),
        if (businessType.value != null) 'business_type': businessType.value,
        if (category.value != null) 'category': category.value,
        if (state.value != null) 'state': state.value,
      };
      final existingProfile = hiveService.getBusinessProfile();
      final bool isUpdate =
          existingProfile != null && existingProfile.id != null;
      final response = await _createOrUpdateProfile(
        data: data,
        profileImage: logoImage.value,
        signatureImage: signatureImage.value,
        isUpdate: isUpdate,
        profileId: existingProfile?.id.toString(),
      );
      final profile = BusinessProfile.fromJson(response['data']);
      await hiveService.saveBusinessProfile(profile);
      hasChanges.value = false;
      Get.snackbar(
        'Success',
        isUpdate
            ? 'Profile updated successfully'
            : 'Profile created successfully',
        backgroundColor: Colors.green,
      );
      logger.i('Saved business profile: ${profile.name}');
    } catch (e, stackTrace) {
      logger.e('Error saving business profile: $e', e, stackTrace);
      Get.snackbar(
        'Error',
        'Error saving profile: $e',
        backgroundColor: Colors.red,
      );
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> updatePassword() async {
    if (newPassword.value != confirmPassword.value) {
      Get.snackbar(
        'Error',
        'New passwords do not match',
        backgroundColor: Colors.red,
      );
      return;
    }

    try {
      final response = await dioClient.dio.post(
        passwordResetUrl,
        data: {
          'current_password': currentPassword.value.trim(),
          'password': newPassword.value.trim(),
          'password_confirmation': confirmPassword.value.trim(),
        },
      );
      if (response.statusCode == 200) {
        showPasswordModal.value = false;
        currentPassword.value = '';
        newPassword.value = '';
        confirmPassword.value = '';
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
        Get.snackbar(
          'Success',
          'Password updated successfully',
          backgroundColor: Colors.green,
        );
        logger.i('Password updated successfully');
      } else {
        logger.w('Failed to update password: ${response.data}');
        Get.snackbar(
          'Error',
          response.data['message'] ?? 'Failed to update password',
          backgroundColor: Colors.red,
        );
      }
    } catch (e, stackTrace) {
      logger.e('Error updating password: $e', e, stackTrace);
      Get.snackbar(
        'Error',
        'Error updating password: $e',
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> pickImage(bool isLogo) async {
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 70,
      );
      if (image != null) {
        final file = XFile(image.path);
        if (isLogo) {
          logoImage.value = file;
        } else {
          signatureImage.value = file;
        }
        hasChanges.value = true;
        logger.i('Picked image: ${image.path}');
      }
    } catch (e, stackTrace) {
      logger.e('Error picking image: $e', e, stackTrace);
      Get.snackbar(
        'Error',
        'Error picking image: $e',
        backgroundColor: Colors.red,
      );
    }
  }

  double getCompletionPercent() {
    int filled = 0;
    const totalFields = 12;
    if (name.value.isNotEmpty) filled++;
    if (phone.value.isNotEmpty) filled++;
    if (tin.value.isNotEmpty) filled++;
    if (email.value.isNotEmpty) filled++;
    if (gst.value.isNotEmpty) filled++;
    if (pincode.value.isNotEmpty) filled++;
    if (address.value.isNotEmpty) filled++;
    if (businessType.value != null) filled++;
    if (category.value != null) filled++;
    if (state.value != null) filled++;
    if (logoImage.value != null) filled++;
    if (signatureImage.value != null) filled++;
    return filled / totalFields;
  }

  @override
  void onClose() {
    businessNameController.dispose();
    mobileController.dispose();
    tinController.dispose();
    emailController.dispose();
    gstController.dispose();
    pincodeController.dispose();
    addressController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
