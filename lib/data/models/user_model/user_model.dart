class User {
  final String id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'email': email};
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        id: map['id'] ?? '',
        name: map['name'] ?? '',
        email: map['email'] ?? '');
  }

  static User? fromMapNullable(Map<String, dynamic>? map) {
    if (map == null) return null;
    return User(
        id: map['id'] ?? '',
        name: map['name'] ?? '',
        email: map['email'] ?? '');
  }
}
