import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BusinessProfileUtils {
  static const List<String> businessTypes = [
    'Sole Proprietorship',
    'Partnership',
    'Private Limited Company',
    'Public Limited Company',
    'LLP',
  ];

  static const List<String> categories = [
    'Retail',
    'Wholesale',
    'Manufacturing',
    'Service Provider',
    'Trading',
    'Consulting',
  ];

  static const List<String> states = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
  ];

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email Address is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? validatePincode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Pincode is required';
    }
    if (value.length != 6) {
      return 'Pincode must be 6 digits';
    }
    return null;
  }

  static Future<void> pickImage({
    required ImagePicker picker,
    required Function(File) onImagePicked,
    required BuildContext context,
  }) async {
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      if (image != null) {
        onImagePicked(File(image.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  static Future<Map<String, dynamic>?> loadBusinessProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileData = prefs.getString('business_profile');
      if (profileData != null) {
        return json.decode(profileData);
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  static Future<void> saveBusinessProfile(
    Map<String, dynamic> profileData,
    BuildContext context,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('business_profile', json.encode(profileData));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving profile: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
