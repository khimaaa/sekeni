enum UserRole {
  tenant,
  owner,
  hotel,
}

extension UserRoleLabel on UserRole {
  String get title {
    switch (this) {
      case UserRole.tenant:
        return 'Allongement';
      case UserRole.owner:
        return 'Propriétaire';
      case UserRole.hotel:
        return 'Hôtel';
    }
  }
}
