import 'family.dart';

/// Request model for updating an existing family.
class UpdateFamilyRequest {
  UpdateFamilyRequest({
    this.name,
    this.subscriptionTier,
    this.settings,
  });

  final String? name;
  final SubscriptionTier? subscriptionTier;
  final Map<String, dynamic>? settings;

  Map<String, dynamic> toJson() => {
        if (name != null) 'name': name,
        if (subscriptionTier != null)
          'subscriptionTier': subscriptionTier!.name,
        if (settings != null) 'settings': settings,
      };
}
