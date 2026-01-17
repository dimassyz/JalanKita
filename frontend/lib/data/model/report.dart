import 'dart:convert';

class Report {
  final int? id;
  final String? title;
  final String? description;
  final String? latitude;
  final String? longitude;
  final String? imagePath;
  final String? imageUrl;
  final String? status;
  final int? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Report({
    this.id,
    this.title,
    this.description,
    this.latitude,
    this.longitude,
    this.imagePath,
    this.imageUrl,
    this.status,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  // Helper untuk mendapatkan URL gambar yang valid
  String? get image => imageUrl ?? imagePath;

  Report copyWith({
    int? id,
    String? title,
    String? description,
    String? latitude,
    String? longitude,
    String? imagePath,
    String? imageUrl,
    String? status,
    int? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Report(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    imagePath: imagePath ?? this.imagePath,
    imageUrl: imageUrl ?? this.imageUrl,
    status: status ?? this.status,
    userId: userId ?? this.userId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory Report.fromJson(String str) => Report.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Report.fromMap(Map<String, dynamic> json) => Report(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    imagePath: json["image_path"],
    imageUrl: json["image_url"],
    status: json["status"],
    userId: json["user_id"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "description": description,
    "latitude": latitude,
    "longitude": longitude,
    "image_path": imagePath,
    "image_url": imageUrl,
    "status": status,
    "user_id": userId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
