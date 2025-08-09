// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family.dart';

FamilyMember _$FamilyMemberFromJson(Map<String, dynamic> json) => FamilyMember(
      userId: json['userId'] as String,
      role: $enumDecode(_$FamilyRoleEnumMap, json['role']),
      permissions: (json['permissions'] as List<dynamic>?)?.map((e) => e as String).toList(),
      joinedAt: DateTime.parse(json['joinedAt'] as String),
    );

Map<String, dynamic> _$FamilyMemberToJson(FamilyMember instance) => <String, dynamic>{
      'userId': instance.userId,
      'role': _$FamilyRoleEnumMap[instance.role]!,
      'permissions': instance.permissions,
      'joinedAt': instance.joinedAt.toIso8601String(),
    };

Family _$FamilyFromJson(Map<String, dynamic> json) => Family(
      id: json['id'] as String,
      name: json['name'] as String,
      createdBy: json['createdBy'] as String,
      subscriptionTier: $enumDecode(_$SubscriptionTierEnumMap, json['subscriptionTier']),
      settings: json['settings'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      members: (json['members'] as List<dynamic>?)
          ?.map((e) => FamilyMember.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FamilyToJson(Family instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'createdBy': instance.createdBy,
      'subscriptionTier': _$SubscriptionTierEnumMap[instance.subscriptionTier]!,
      'settings': instance.settings,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'members': instance.members?.map((e) => e.toJson()).toList(),
    };

const Map<FamilyRole, String> _$FamilyRoleEnumMap = {
  FamilyRole.parent: 'parent',
  FamilyRole.child: 'child',
  FamilyRole.guardian: 'guardian',
  FamilyRole.admin: 'admin',
};

const Map<SubscriptionTier, String> _$SubscriptionTierEnumMap = {
  SubscriptionTier.basic: 'basic',
  SubscriptionTier.family: 'family',
  SubscriptionTier.premium: 'premium',
};

