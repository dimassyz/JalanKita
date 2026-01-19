class UpdateProfileRequest {
  final String name;
  final String phone;
  final String alamat;

  UpdateProfileRequest({
    required this.name,
    required this.phone,
    required this.alamat,
  });

  Map<String, String> toMap() => {
    "name": name,
    "phone_number": phone,
    "alamat_lengkap": alamat,
  };
}
