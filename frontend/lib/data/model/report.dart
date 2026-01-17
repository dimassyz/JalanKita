import 'dart:convert';

class Report {
  final int id;
  final int userId;
  final String title;
  final String description;
  final String imagePath;
  final String status;
  final dynamic latitude;
  final dynamic longitude;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String imageUrl;

  Report({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
    required this.imageUrl,
  });

  Report copyWith({
    int? id,
    int? userId,
    String? title,
    String? description,
    String? imagePath,
    String? status,
    dynamic latitude,
    dynamic longitude,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? imageUrl,
  }) => Report(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    title: title ?? this.title,
    description: description ?? this.description,
    imagePath: imagePath ?? this.imagePath,
    status: status ?? this.status,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    imageUrl: imageUrl ?? this.imageUrl,
  );

  factory Report.fromJson(String str) => Report.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Report.fromMap(Map<String, dynamic> json) => Report(
    id: json["id"],
    userId: json["user_id"],
    title: json["title"],
    description: json["description"],
    imagePath: json["image_path"],
    status: json["status"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    imageUrl: json["image_url"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "user_id": userId,
    "title": title,
    "description": description,
    "image_path": imagePath,
    "status": status,
    "latitude": latitude,
    "longitude": longitude,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "image_url": imageUrl,
  };
}
