import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/core/gloabl_widgets/sidebar/admin_sidebar_wrapper.dart';
import 'package:greenbiller/features/settings/controller/bussiness_profile_controller.dart';

import 'package:greenbiller/features/settings/utils/business_profile_utils.dart';
import 'package:greenbiller/features/settings/view/business_profile_form.dart';

class BusinessProfilePage extends GetView<BusinessProfileController> {
  const BusinessProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminSidebarWrapper(
      title: 'Business Profile',
      child: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator(color: accentColor))
            : WillPopScope(
                onWillPop: () async {
                  if (!controller.hasChanges.value) return true;
                  final shouldPop = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Unsaved Changes'),
                      content: const Text(
                        'You have unsaved changes. Are you sure you want to leave?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text(
                            'Leave',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                  return shouldPop ?? false;
                },
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 160,
                            child: BusinessProfileForm.buildLogoSection(
                              completionPercent: controller
                                  .getCompletionPercent(),
                              logoImage: controller.logoImage.value != null
                                  ? File(controller.logoImage.value!.path)
                                  : (controller.logoImageFile.value.isNotEmpty
                                        ? controller
                                              .logoImageFile
                                              .value // URL
                                        : null),
                              onEdit: () => controller.pickImage(true),
                            ),
                          ),

                          const SizedBox(height: 16),
                          Form(
                            key: controller.formKey,
                            child: Column(
                              children: [
                                BusinessProfileForm.buildCard(
                                  title: 'Business Details',
                                  icon: Icons.business,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: BusinessProfileForm.buildTextField(
                                              controller: controller
                                                  .businessNameController,
                                              label: 'Business Name *',
                                              hint: 'Enter business name',
                                              validator: (value) =>
                                                  BusinessProfileUtils.validateRequired(
                                                    value,
                                                    'Business Name',
                                                  ),
                                              onChanged: () =>
                                                  controller
                                                      .name
                                                      .value = controller
                                                      .businessNameController
                                                      .text,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: BusinessProfileForm.buildTextField(
                                              controller:
                                                  controller.mobileController,
                                              label: 'Mobile Number *',
                                              hint: 'Enter mobile number',
                                              keyboardType: TextInputType.phone,
                                              validator: (value) =>
                                                  BusinessProfileUtils.validateRequired(
                                                    value,
                                                    'Mobile Number',
                                                  ),
                                              onChanged: () =>
                                                  controller.phone.value =
                                                      controller
                                                          .mobileController
                                                          .text,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Expanded(
                                            child:
                                                BusinessProfileForm.buildTextField(
                                                  controller: controller
                                                      .emailController,
                                                  label: 'Email Address',
                                                  hint: 'Enter email address',
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  validator:
                                                      BusinessProfileUtils
                                                          .validateEmail,
                                                  onChanged: () =>
                                                      controller.email.value =
                                                          controller
                                                              .emailController
                                                              .text,
                                                ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child:
                                                BusinessProfileForm.buildTextField(
                                                  controller:
                                                      controller.tinController,
                                                  label: 'TIN Number',
                                                  hint: 'Enter TIN number',
                                                  onChanged: () =>
                                                      controller.tin.value =
                                                          controller
                                                              .tinController
                                                              .text,
                                                ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      BusinessProfileForm.buildTextField(
                                        controller: controller.gstController,
                                        label: 'GST Number',
                                        hint: 'Enter GST number',
                                        onChanged: () => controller.gst.value =
                                            controller.gstController.text,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                BusinessProfileForm.buildCard(
                                  title: 'Additional Details',
                                  icon: Icons.location_on,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: BusinessProfileForm.buildDropdown(
                                              value:
                                                  controller.businessType.value,
                                              label: 'Business Type *',
                                              hint: 'Select business type',
                                              items: BusinessProfileUtils
                                                  .businessTypes,
                                              onChanged: (value) =>
                                                  controller
                                                          .businessType
                                                          .value =
                                                      value,
                                              validator: (value) =>
                                                  BusinessProfileUtils.validateRequired(
                                                    value,
                                                    'Business Type',
                                                  ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: BusinessProfileForm.buildDropdown(
                                              value: controller.category.value,
                                              label: 'Category *',
                                              hint: 'Select category',
                                              items: BusinessProfileUtils
                                                  .categories,
                                              onChanged: (value) =>
                                                  controller.category.value =
                                                      value,
                                              validator: (value) =>
                                                  BusinessProfileUtils.validateRequired(
                                                    value,
                                                    'Category',
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: BusinessProfileForm.buildDropdown(
                                              value: controller.state.value,
                                              label: 'State *',
                                              hint: 'Select state',
                                              items:
                                                  BusinessProfileUtils.states,
                                              onChanged: (value) =>
                                                  controller.state.value =
                                                      value,
                                              validator: (value) =>
                                                  BusinessProfileUtils.validateRequired(
                                                    value,
                                                    'State',
                                                  ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: BusinessProfileForm.buildTextField(
                                              controller:
                                                  controller.pincodeController,
                                              label: 'Pincode *',
                                              hint: 'Enter pincode',
                                              keyboardType:
                                                  TextInputType.number,
                                              validator: BusinessProfileUtils
                                                  .validatePincode,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                                LengthLimitingTextInputFormatter(
                                                  6,
                                                ),
                                              ],
                                              onChanged: () =>
                                                  controller.pincode.value =
                                                      controller
                                                          .pincodeController
                                                          .text,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      BusinessProfileForm.buildTextField(
                                        controller:
                                            controller.addressController,
                                        label: 'Address *',
                                        hint: 'Enter complete address',
                                        maxLines: 3,
                                        validator: (value) =>
                                            BusinessProfileUtils.validateRequired(
                                              value,
                                              'Address',
                                            ),
                                        onChanged: () =>
                                            controller.address.value =
                                                controller
                                                    .addressController
                                                    .text,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                BusinessProfileForm.buildCard(
                                  title: 'Digital Signature',
                                  icon: Icons.upload,
                                  child:
                                      BusinessProfileForm.buildSignatureSection(
                                        signatureImage:
                                            controller.signatureImage.value !=
                                                null
                                            ? File(
                                                controller
                                                    .signatureImage
                                                    .value!
                                                    .path,
                                              )
                                            : null,
                                        onEdit: () =>
                                            controller.pickImage(false),
                                      ),
                                ),
                                const SizedBox(height: 16),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Obx(
                                    () => Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (controller.hasChanges.value)
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.orange,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: const Text(
                                              'Unsaved',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        const SizedBox(width: 8),
                                        ElevatedButton.icon(
                                          onPressed:
                                              controller.showPasswordModal.value
                                              ? null
                                              : () =>
                                                    controller
                                                            .showPasswordModal
                                                            .value =
                                                        true,
                                          icon: const Icon(
                                            Icons.lock,
                                            size: 14,
                                            color: Colors.white,
                                          ),
                                          label: const Text(
                                            'Update Password',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: accentColor
                                                .withOpacity(0.8),
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 8,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        ElevatedButton.icon(
                                          onPressed: controller.isSaving.value
                                              ? null
                                              : controller.saveProfile,
                                          icon: controller.isSaving.value
                                              ? const SizedBox(
                                                  width: 14,
                                                  height: 14,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor:
                                                        AlwaysStoppedAnimation(
                                                          Colors.white,
                                                        ),
                                                  ),
                                                )
                                              : const Icon(
                                                  Icons.save,
                                                  size: 14,
                                                ),
                                          label: Text(
                                            controller.isSaving.value
                                                ? 'Saving...'
                                                : 'Save Profile',
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: accentColor,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 8,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (controller.showPasswordModal.value)
                      Container(
                        color: Colors.black54,
                        child: Center(
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 360),
                            margin: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x1A000000),
                                  blurRadius: 16,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Update Password',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () =>
                                            controller.showPasswordModal.value =
                                                false,
                                        icon: const Icon(
                                          Icons.close,
                                          size: 20,
                                          color: Color(0xFF9CA3AF),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Column(
                                    children: [
                                      BusinessProfileForm.buildPasswordField(
                                        controller: controller
                                            .currentPasswordController,
                                        label: 'Current Password *',
                                        hint: 'Enter current password',
                                        isVisible: controller
                                            .showCurrentPassword
                                            .value,
                                        onToggleVisibility: () => controller
                                            .showCurrentPassword
                                            .toggle(),
                                      ),
                                      const SizedBox(height: 12),
                                      BusinessProfileForm.buildPasswordField(
                                        controller:
                                            controller.newPasswordController,
                                        label: 'New Password *',
                                        hint: 'Enter new password',
                                        isVisible:
                                            controller.showNewPassword.value,
                                        onToggleVisibility: () =>
                                            controller.showNewPassword.toggle(),
                                      ),
                                      const SizedBox(height: 12),
                                      BusinessProfileForm.buildPasswordField(
                                        controller: controller
                                            .confirmPasswordController,
                                        label: 'Confirm New Password *',
                                        hint: 'Confirm new password',
                                        isVisible: controller
                                            .showConfirmPassword
                                            .value,
                                        onToggleVisibility: () => controller
                                            .showConfirmPassword
                                            .toggle(),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      top: BorderSide(color: Color(0xFFE5E7EB)),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () =>
                                            controller.showPasswordModal.value =
                                                false,
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF6B7280),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      ElevatedButton(
                                        onPressed: controller.updatePassword,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: accentColor,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          'Update Password',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
