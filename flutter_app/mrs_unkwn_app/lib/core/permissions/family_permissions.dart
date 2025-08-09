import "../../features/family/data/models/family.dart";

enum FamilyPermission { manageMembers, viewActivity, editSettings, deleteFamily }

class FamilyPermissions {
  const FamilyPermissions._();

  static const Map<FamilyRole, Set<FamilyPermission>> _rolePermissions = {
    FamilyRole.parent: {
      FamilyPermission.manageMembers,
      FamilyPermission.viewActivity,
      FamilyPermission.editSettings,
      FamilyPermission.deleteFamily,
    },
    FamilyRole.admin: {
      FamilyPermission.manageMembers,
      FamilyPermission.viewActivity,
      FamilyPermission.editSettings,
      FamilyPermission.deleteFamily,
    },
    FamilyRole.guardian: {
      FamilyPermission.manageMembers,
      FamilyPermission.viewActivity,
    },
    FamilyRole.child: {
      FamilyPermission.viewActivity,
    },
  };

  static bool hasPermission(
    FamilyRole role,
    FamilyPermission permission,
  ) {
    return _rolePermissions[role]?.contains(permission) ?? false;
  }
}
