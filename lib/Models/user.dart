class User {
  final int id;
  final String name;
  final String email;
  final String telepon;
  final String alamat;
  final String? foto_profil;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.telepon,
    required this.alamat,
    this.foto_profil
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      telepon: json['telepon'],
      alamat: json['alamat'],

    );
  }
}
