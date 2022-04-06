class AppUser {
  final String id;
  final String? email;
  final String? photoUrl;
  final String? name;

  const AppUser({
    required this.id,
    this.name,
    this.email,
    this.photoUrl,
  });

  static const empty = AppUser(id: '');

  bool get isEmpty => id == "";
}
