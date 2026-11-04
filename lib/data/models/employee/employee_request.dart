class EmployeeRequest {
  final int? id;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String? password;
  final String? confirmPassword;
  final String role;
  final String status;
  final String? profile;

  EmployeeRequest({
    this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    this.password,
    this.confirmPassword,
    this.role = 'USER',
    this.status = 'ACT',
    this.profile = '',
  });

  Map<String, dynamic> toCreateJson() {
    return {
      'username': username.trim(),
      'firstName': firstName.trim(),
      'lastName': lastName.trim(),
      'email': email.trim(),
      'phoneNumber': phoneNumber.trim(),
      'password': password ?? '',
      'confirmPassword': confirmPassword ?? password ?? '',
      'role': role,
      'status': status,
      'profile': profile ?? '',
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'id': id,
      'username': username.trim(),
      'firstName': firstName.trim(),
      'lastName': lastName.trim(),
      'email': email.trim(),
      'phoneNumber': phoneNumber.trim(),
      'password': (password != null && password!.isNotEmpty) ? password : '',
      'role': role,
      'status': status,
      'profile': profile ?? '',
    };
  }
}

