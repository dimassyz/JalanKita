class RegisterRequest {
    final String name;
    final String username;
    final String nik;
    final String email;
    final String alamatLengkap;
    final String phoneNumber;
    final String password;

    RegisterRequest({
        required this.name,
        required this.username,
        required this.nik,
        required this.email,
        required this.alamatLengkap,
        required this.phoneNumber,
        required this.password,
    });

    Map<String, dynamic> toMap() => {
        "name": name,
        "username": username,
        "nik": nik,
        "email": email,
        "alamat_lengkap": alamatLengkap,
        "phone_number": phoneNumber,
        "password": password,
    };
}
