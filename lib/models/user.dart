class AppUser {
  final String id;
  final String fullName;
  final String email;

  const AppUser({required this.id, required this.fullName, required this.email});

  AppUser copyWith({String? id, String? fullName, String? email}) => AppUser(
        id: id ?? this.id,
        fullName: fullName ?? this.fullName,
        email: email ?? this.email,
      );

  String get initials {
    final parts = fullName.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : 'U';
  }
}