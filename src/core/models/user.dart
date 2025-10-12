class User {
  final String? id;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? photoUrl;
  final DateTime? createdAt;
  final DateTime? lastLoginAt;

  User({
    this.id,
    this.name,
    this.email,
    this.photoUrl,
    this.createdAt,
    this.lastLoginAt,
    this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      photoUrl: json['photoUrl'],
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ""),
      lastLoginAt: DateTime.tryParse(json['lastLoginAt']?.toString() ?? ""),
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson(
      {bool? trimNulls, bool useDateTimeFormat = false}) {
    final data = {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'createdAt': createdAt?.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'phoneNumber': phoneNumber,
    };

    if (trimNulls == true) {
      data.removeWhere((key, value) => value == null);
    }

    return data;
  }
}
