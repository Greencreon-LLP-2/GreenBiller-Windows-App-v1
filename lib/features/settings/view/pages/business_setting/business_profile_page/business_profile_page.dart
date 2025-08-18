import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/settings/view/pages/business_setting/business_profile_page/business_profile_form.dart';
import 'package:green_biller/features/settings/view/pages/business_setting/business_profile_page/business_profile_utils.dart';
import 'package:green_biller/features/settings/view/pages/business_setting/models/business_profile_model.dart';
import 'package:green_biller/utils/custom_appbar.dart';
import 'package:image_picker/image_picker.dart';

class BusinessProfilePage extends StatefulWidget {
  const BusinessProfilePage({super.key});

  @override
  State<BusinessProfilePage> createState() => _BusinessProfilePageState();
}

class _BusinessProfilePageState extends State<BusinessProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _businessNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _tinController = TextEditingController();
  final _emailController = TextEditingController();
  final _gstController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _addressController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  File? _logoImage;
  File? _signatureImage;
  String? _selectedBusinessType;
  String? _selectedCategory;
  String? _selectedState;

  bool _showPasswordModal = false;
  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;
  bool _isLoading = false;
  bool _isSaving = false;
  bool _hasChanges = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadBusinessProfile();
    _setupChangeListeners();
  }

  void _setupChangeListeners() {
    for (var controller in [
      _businessNameController,
      _mobileController,
      _tinController,
      _emailController,
      _gstController,
      _pincodeController,
      _addressController,
    ]) {
      controller.addListener(_onFieldChanged);
    }
  }

  void _onFieldChanged() {
    if (!_hasChanges) setState(() => _hasChanges = true);
  }

  Future<void> _loadBusinessProfile() async {
    setState(() => _isLoading = true);
    final profileData = await BusinessProfileUtils.loadBusinessProfile();
    if (profileData != null) {
      final profile = BusinessProfile.fromJson(profileData);
      setState(() {
        _businessNameController.text = profile.businessName ?? '';
        _mobileController.text = profile.mobile ?? '';
        _tinController.text = profile.tin ?? '';
        _emailController.text = profile.email ?? '';
        _gstController.text = profile.gst ?? '';
        _pincodeController.text = profile.pincode ?? '';
        _addressController.text = profile.address ?? '';
        _selectedBusinessType = profile.businessType;
        _selectedCategory = profile.category;
        _selectedState = profile.state;
        if (profile.profileImagePath != null) {
          _logoImage = File(profile.profileImagePath!);
        }
        if (profile.signatureImagePath != null) {
          _signatureImage = File(profile.signatureImagePath!);
        }
      });
    }
    setState(() {
      _isLoading = false;
      _hasChanges = false;
    });
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final profileData = <String, dynamic>{
      'business_name': _businessNameController.text.trim(),
      'mobile': _mobileController.text.trim(),
      'email': _emailController.text.trim(),
      'pincode': _pincodeController.text.trim(),
      'address': _addressController.text.trim(),
      if (_tinController.text.isNotEmpty) 'tin': _tinController.text.trim(),
      if (_gstController.text.isNotEmpty) 'gst': _gstController.text.trim(),
      if (_selectedBusinessType != null) 'business_type': _selectedBusinessType,
      if (_selectedCategory != null) 'category': _selectedCategory,
      if (_selectedState != null) 'state': _selectedState,
      if (_logoImage != null) 'profile_image_path': _logoImage!.path,
      if (_signatureImage != null)
        'signature_image_path': _signatureImage!.path,
    };

    final profile = BusinessProfile(
      name: _businessNameController.text.trim(),
      phone: _mobileController.text.trim(),
      tin: _tinController.text.trim(),
      email: _emailController.text.trim(),
      pincode: _pincodeController.text.trim(),
      address: _addressController.text.trim(),
      businessType: _selectedBusinessType,
      category: _selectedCategory,
      state: _selectedState,
      gst: _gstController.text.trim(),
      profileImagePath: _logoImage?.path,
      signatureImagePath: _signatureImage?.path,
      businessName: _businessNameController.text.trim(),
      mobile: _mobileController.text.trim(),
    );

    await BusinessProfileUtils.saveBusinessProfile(profile.toJson(), context);
    debugPrint('Profile Data Map: ${json.encode(profileData)}');

    setState(() {
      _hasChanges = false;
      _isSaving = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully!'),
        backgroundColor: accentColor,
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (!_hasChanges) return true;
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsaved Changes'),
        content: const Text(
            'You have unsaved changes. Are you sure you want to leave?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Leave', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    return shouldPop ?? false;
  }

  double _getCompletionPercent() {
    int filled = 0;
    const totalFields = 12;
    if (_businessNameController.text.isNotEmpty) filled++;
    if (_mobileController.text.isNotEmpty) filled++;
    if (_tinController.text.isNotEmpty) filled++;
    if (_emailController.text.isNotEmpty) filled++;
    if (_gstController.text.isNotEmpty) filled++;
    if (_pincodeController.text.isNotEmpty) filled++;
    if (_addressController.text.isNotEmpty) filled++;
    if (_selectedBusinessType != null) filled++;
    if (_selectedCategory != null) filled++;
    if (_selectedState != null) filled++;
    if (_logoImage != null) filled++;
    if (_signatureImage != null) filled++;
    return filled / totalFields;
  }

  Future<void> _updatePassword() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New passwords do not match'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Placeholder for API call
    setState(() {
      _showPasswordModal = false;
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password updated successfully!'),
        backgroundColor: accentColor,
      ),
    );
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _mobileController.dispose();
    _tinController.dispose();
    _emailController.dispose();
    _gstController.dispose();
    _pincodeController.dispose();
    _addressController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: accentColor)),
      );
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: GradientAppBar(
          title: 'Business Profile',
          subtitle: 'Manage your business information and branding',
          gradientColor: accentColor,
          actions: [
            if (_hasChanges)
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Unsaved',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ElevatedButton.icon(
              onPressed: () => setState(() => _showPasswordModal = true),
              icon: const Icon(Icons.lock, size: 16, color: Colors.white),
              label: const Text('Update Password'),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor.withOpacity(0.1),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return constraints.maxWidth > 1024
                            ? _buildDesktopLayout()
                            : _buildMobileLayout();
                      },
                    ),
                  ),
                ),
              ],
            ),
            if (_showPasswordModal) _buildPasswordModal(),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 200,
          child: BusinessProfileForm.buildLogoSection(
            completionPercent: _getCompletionPercent(),
            logoImage: _logoImage,
            onEdit: () => BusinessProfileUtils.pickImage(
              picker: _picker,
              onImagePicked: (image) => setState(() {
                _logoImage = image;
                _hasChanges = true;
              }),
              context: context,
            ),
          ),
        ),
        const SizedBox(height: 24),
        _buildFormSection(),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 200,
          child: BusinessProfileForm.buildLogoSection(
            completionPercent: _getCompletionPercent(),
            logoImage: _logoImage,
            onEdit: () => BusinessProfileUtils.pickImage(
              picker: _picker,
              onImagePicked: (image) => setState(() {
                _logoImage = image;
                _hasChanges = true;
              }),
              context: context,
            ),
          ),
        ),
        const SizedBox(height: 24),
        _buildFormSection(),
      ],
    );
  }

  Widget _buildFormSection() {
    return Form(
      key: _formKey,
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
                        controller: _businessNameController,
                        label: 'Business Name *',
                        hint: 'Enter business name',
                        validator: (value) =>
                            BusinessProfileUtils.validateRequired(
                                value, 'Business Name'),
                        onChanged: _onFieldChanged,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: BusinessProfileForm.buildTextField(
                        controller: _mobileController,
                        label: 'Mobile Number *',
                        hint: 'Enter mobile number',
                        keyboardType: TextInputType.phone,
                        validator: (value) =>
                            BusinessProfileUtils.validateRequired(
                                value, 'Mobile Number'),
                        onChanged: _onFieldChanged,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: BusinessProfileForm.buildTextField(
                        controller: _emailController,
                        label: 'Email Address *',
                        hint: 'Enter email address',
                        keyboardType: TextInputType.emailAddress,
                        validator: BusinessProfileUtils.validateEmail,
                        onChanged: _onFieldChanged,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: BusinessProfileForm.buildTextField(
                        controller: _tinController,
                        label: 'TIN Number',
                        hint: 'Enter TIN number',
                        onChanged: _onFieldChanged,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                BusinessProfileForm.buildTextField(
                  controller: _gstController,
                  label: 'GST Number',
                  hint: 'Enter GST number',
                  onChanged: _onFieldChanged,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          const SizedBox(height: 24),
          BusinessProfileForm.buildCard(
            title: 'Additional Details',
            icon: Icons.location_on,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: BusinessProfileForm.buildDropdown(
                        value: _selectedBusinessType,
                        label: 'Business Type *',
                        hint: 'Select business type',
                        items: BusinessProfileUtils.businessTypes,
                        onChanged: (value) {
                          setState(() => _selectedBusinessType = value);
                          _onFieldChanged();
                        },
                        validator: (value) =>
                            BusinessProfileUtils.validateRequired(
                                value, 'Business Type'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: BusinessProfileForm.buildDropdown(
                        value: _selectedCategory,
                        label: 'Category *',
                        hint: 'Select category',
                        items: BusinessProfileUtils.categories,
                        onChanged: (value) {
                          setState(() => _selectedCategory = value);
                          _onFieldChanged();
                        },
                        validator: (value) =>
                            BusinessProfileUtils.validateRequired(
                                value, 'Category'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: BusinessProfileForm.buildDropdown(
                        value: _selectedState,
                        label: 'State *',
                        hint: 'Select state',
                        items: BusinessProfileUtils.states,
                        onChanged: (value) {
                          setState(() => _selectedState = value);
                          _onFieldChanged();
                        },
                        validator: (value) =>
                            BusinessProfileUtils.validateRequired(
                                value, 'State'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: BusinessProfileForm.buildTextField(
                        controller: _pincodeController,
                        label: 'Pincode *',
                        hint: 'Enter pincode',
                        keyboardType: TextInputType.number,
                        validator: BusinessProfileUtils.validatePincode,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                        ],
                        onChanged: _onFieldChanged,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                BusinessProfileForm.buildTextField(
                  controller: _addressController,
                  label: 'Address *',
                  hint: 'Enter complete address',
                  maxLines: 3,
                  validator: (value) =>
                      BusinessProfileUtils.validateRequired(value, 'Address'),
                  onChanged: _onFieldChanged,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          BusinessProfileForm.buildCard(
            title: 'Digital Signature',
            icon: Icons.upload,
            child: BusinessProfileForm.buildSignatureSection(
              signatureImage: _signatureImage,
              onEdit: () => BusinessProfileUtils.pickImage(
                picker: _picker,
                onImagePicked: (image) => setState(() {
                  _signatureImage = image;
                  _hasChanges = true;
                }),
                context: context,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: _isSaving ? null : _saveProfile,
              icon: _isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save, size: 16),
              label: Text(_isSaving ? 'Saving...' : 'Save Profile'),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordModal() {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Update Password',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    IconButton(
                      onPressed: () =>
                          setState(() => _showPasswordModal = false),
                      icon: const Icon(Icons.close),
                      color: const Color(0xFF9CA3AF),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    BusinessProfileForm.buildPasswordField(
                      controller: _currentPasswordController,
                      label: 'Current Password *',
                      hint: 'Enter current password',
                      isVisible: _showCurrentPassword,
                      onToggleVisibility: () => setState(
                          () => _showCurrentPassword = !_showCurrentPassword),
                    ),
                    const SizedBox(height: 16),
                    BusinessProfileForm.buildPasswordField(
                      controller: _newPasswordController,
                      label: 'New Password *',
                      hint: 'Enter new password',
                      isVisible: _showNewPassword,
                      onToggleVisibility: () =>
                          setState(() => _showNewPassword = !_showNewPassword),
                    ),
                    const SizedBox(height: 16),
                    BusinessProfileForm.buildPasswordField(
                      controller: _confirmPasswordController,
                      label: 'Confirm New Password *',
                      hint: 'Confirm new password',
                      isVisible: _showConfirmPassword,
                      onToggleVisibility: () => setState(
                          () => _showConfirmPassword = !_showConfirmPassword),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () =>
                          setState(() => _showPasswordModal = false),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Color(0xFF6B7280)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _updatePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Update Password'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
