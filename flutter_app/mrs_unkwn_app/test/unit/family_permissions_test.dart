import 'package:flutter_test/flutter_test.dart';

import 'package:mrs_unkwn_app/core/permissions/family_permissions.dart';
import 'package:mrs_unkwn_app/features/family/data/models/family.dart';

void main() {
  test('parent has manage members permission', () {
    expect(
      FamilyPermissions.hasPermission(
        FamilyRole.parent,
        FamilyPermission.manageMembers,
      ),
      isTrue,
    );
  });

  test('child lacks edit settings permission', () {
    expect(
      FamilyPermissions.hasPermission(
        FamilyRole.child,
        FamilyPermission.editSettings,
      ),
      isFalse,
    );
  });
}
