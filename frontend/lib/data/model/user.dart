import 'dart:convert';

class User {
  final String? name;
  final String? username;
  final String? nik;
  final String? email;
  final String? alamatLengkap;
  final String? phoneNumber;
  final String? role;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final int? id;

  User({
    this.name,
    this.username,
    this.nik,
    this.email,
    this.alamatLengkap,
    this.phoneNumber,
    this.role,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  User copyWith({
    String? name,
    String? username,
    String? nik,
    String? email,
    String? alamatLengkap,
    String? phoneNumber,
    String? role,
    DateTime? updatedAt,
    DateTime? createdAt,
    int? id,
  }) => User(
    name: name ?? this.name,
    username: username ?? this.username,
    nik: nik ?? this.nik,
    email: email ?? this.email,
    alamatLengkap: alamatLengkap ?? this.alamatLengkap,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    role: role ?? this.role,
    updatedAt: updatedAt ?? this.updatedAt,
    createdAt: createdAt ?? this.createdAt,
    id: id ?? this.id,
  );

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
    name: json["name"],
    username: json["username"],
    nik: json["nik"],
    email: json["email"],
    alamatLengkap: json["alamat_lengkap"],
    phoneNumber: json["phone_number"],
    role: json["role"],
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "username": username,
    "nik": nik,
    "email": email,
    "alamat_lengkap": alamatLengkap,
    "phone_number": phoneNumber,
    "role": role,
    "updated_at": updatedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "id": id,
  };
}
