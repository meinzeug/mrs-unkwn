import 'family.dart';

/// Request model for creating a new family.
class CreateFamilyRequest {
  CreateFamilyRequest({
    required this.name,
    this.subscriptionTier = SubscriptionTier.basic,
    this.settings,
  });

  final String name;
  final SubscriptionTier subscriptionTier;
  final Map<String, dynamic>? settings;

  Map<String, dynamic> toJson() => {
        'name': name,
        'subscriptionTier': subscriptionTier.name,
        if (settings != null) 'settings': settings,
      };
}
