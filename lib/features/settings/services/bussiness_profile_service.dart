// services/business_profile_service.dart
import 'dart:convert';
import 'package:green_biller/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class BusinessProfileService {
  final String accessToken;

  BusinessProfileService(this.accessToken);

  Map<String, String> get _headers => {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // Fetch business profile
  Future<Map<String, dynamic>> fetchBusinessProfile() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/profile-view'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1 && data['data'] is List && data['data'].isNotEmpty) {
          return data['data'][0];
        }
        return {};
      } else {
        throw Exception('Failed to fetch business profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching business profile: $e');
    }
  }

  // Create or update business profile
  Future<Map<String, dynamic>> saveBusinessProfile(Map<String, dynamic> data, {XFile? profileImage, XFile? signatureImage}) async {
    try {
      // First, try to fetch existing profile to determine if we need to create or update
      final existingProfile = await fetchBusinessProfile();
      
      if (existingProfile.isNotEmpty && existingProfile['id'] != null) {
        // Update existing profile
        return await _updateProfile(existingProfile['id'], data);
      } else {
        // Create new profile
        return await _createProfile(data, profileImage: profileImage, signatureImage: signatureImage);
      }
    } catch (e) {
      throw Exception('Error saving business profile: $e');
    }
  }

  Future<Map<String, dynamic>> _createProfile(Map<String, dynamic> data, {XFile? profileImage, XFile? signatureImage}) async {
    try {
      // Create multipart request for file uploads
      final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/profile-create'));
      request.headers.addAll(_headers);

      // Add files if provided
      if (profileImage != null) {
        final file = await http.MultipartFile.fromPath('profileImagePath', profileImage.path);
        request.files.add(file);
      }

      if (signatureImage != null) {
        final file = await http.MultipartFile.fromPath('signatureImagePath', signatureImage.path);
        request.files.add(file);
      }

      // Add other fields
      data.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });

      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return json.decode(responseData);
      } else {
        throw Exception('Failed to create business profile: ${response.statusCode}');
      }
    } catch (e,stack) {
      print(stack);
      throw Exception('Error creating business profile: $e');
    }
  }

  Future<Map<String, dynamic>> _updateProfile(int id, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/profile-update/$id'),
        headers: _headers,
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to update business profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating business profile: $e');
    }
  }
}