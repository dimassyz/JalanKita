import 'dart:io';

class CreateReportRequest {
  final String title;
  final String description;
  final File image;
  final double latitude;
  final double longitude;

  CreateReportRequest({
    required this.title,
    required this.description,
    required this.image,
    required this.latitude,
    required this.longitude,
  });

  Map<String, String> toMap() => {
    "title": title,
    "description": description,
    "latitude": latitude.toString(),
    "longitude": longitude.toString(),
  };
}
