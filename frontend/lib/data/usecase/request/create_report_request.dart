class CreateReportRequest {
  final String title;
  final String description;
  final String latitude;
  final String longitude;

  CreateReportRequest({
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
  });

  Map<String, String> toMap() {
    return {
      'title': title,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
