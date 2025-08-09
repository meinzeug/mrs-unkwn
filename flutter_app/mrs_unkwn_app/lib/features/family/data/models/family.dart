import 'package:json_annotation/json_annotation.dart';

part 'family.g.dart';

enum FamilyRole { parent, child, guardian, admin }

enum SubscriptionTier { basic, family, premium }

@JsonSerializable(explicitToJson: true)
class FamilyMember {
  final String userId;
  final FamilyRole role;
  final List<String>? permissions;
  final DateTime joinedAt;

  const FamilyMember({
    required this.userId,
    required this.role,
    this.permissions,
    required this.joinedAt,
  });

  factory FamilyMember.fromJson(Map<String, dynamic> json) =>
      _$FamilyMemberFromJson(json);

  Map<String, dynamic> toJson() => _$FamilyMemberToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Family {
  final String id;
  final String name;
  final String createdBy;
  final SubscriptionTier subscriptionTier;
  final Map<String, dynamic>? settings;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<FamilyMember>? members;

  const Family({
    required this.id,
    required this.name,
    required this.createdBy,
    required this.subscriptionTier,
    this.settings,
    required this.createdAt,
    required this.updatedAt,
    this.members,
  });

  factory Family.fromJson(Map<String, dynamic> json) =>
      _$FamilyFromJson(json);

  Map<String, dynamic> toJson() => _$FamilyToJson(this);
}

