// providers/business_profile_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/settings/services/bussiness_profile_service.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';


// Provider for the service that depends on access token
final businessProfileServiceProvider = Provider<BusinessProfileService>((ref) {
  final userModel = ref.watch(userProvider);
  final accessToken = userModel?.accessToken;
  
  if (accessToken == null) {
    throw Exception('Access token not available - User not authenticated');
  }
  
  return BusinessProfileService(accessToken);
});

// Provider for fetching business profile
final businessProfileProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final service = ref.watch(businessProfileServiceProvider);
  try {
    return await service.fetchBusinessProfile();
  } catch (e) {
    // Return empty map instead of throwing to avoid breaking the UI
    return {};
  }
});

// Notifier for saving business profile
final saveBusinessProfileProvider = StateNotifierProvider.autoDispose<SaveBusinessProfileNotifier, AsyncValue<void>>((ref) {
  final service = ref.watch(businessProfileServiceProvider);
  return SaveBusinessProfileNotifier(service, ref);
});

class SaveBusinessProfileNotifier extends StateNotifier<AsyncValue<void>> {
  final BusinessProfileService _service;
  final Ref _ref;

  SaveBusinessProfileNotifier(this._service, this._ref) : super(const AsyncValue.data(null));

  Future<void> saveProfile(Map<String, dynamic> data, {XFile? profileImage, XFile? signatureImage}) async {
    state = const AsyncValue.loading();
    try {
      await _service.saveBusinessProfile(data, profileImage: profileImage, signatureImage: signatureImage);
      state = const AsyncValue.data(null);
      
      // Invalidate the fetch provider to refresh data after save
      _ref.invalidate(businessProfileProvider);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}