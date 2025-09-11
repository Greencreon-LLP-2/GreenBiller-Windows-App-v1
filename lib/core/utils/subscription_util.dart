import 'package:greenbiller/features/auth/model/user_model.dart';

class SubscriptionUtil {
  /// Checks if the user has a valid subscription (trial or paid).
  /// By default, free trial is disabled. Only paid subscriptions are valid.
  static bool hasValidSubscription(UserModel? user, {bool allowTrial = false}) {
    if (user == null) return false;

    final now = DateTime.now();

    // --- Trial check (optional) ---
    if (allowTrial &&
        (user.subscriptionId == null ||
            user.subscriptionId.toString().isEmpty) &&
        user.createdAt != null) {
      final trialEnds = user.createdAt!.add(const Duration(days: 30));

      final trialValid = now.isBefore(trialEnds);

      return trialValid;
    }

    // --- Paid subscription check ---
    if (user.subscriptionId != null &&
        user.subscriptionId.toString().isNotEmpty) {
      DateTime? endDate;

      if (user.subscriptionEnd is DateTime) {
        endDate = user.subscriptionEnd as DateTime;
      } else if (user.subscriptionEnd is String) {
        endDate = DateTime.tryParse(user.subscriptionEnd as String);
      }

      if (endDate != null) {
        final subscriptionValid = now.isBefore(endDate);
        
        return subscriptionValid;
      }
    }

    // No valid trial or subscription
    return false;
  }
}
