class EmployeeModel {
  final int? id;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String role;
  final String status;
  final String? profile;
  final String? createAt;

  EmployeeModel({
    this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    this.role = 'USER',
    this.status = 'ACT',
    this.profile,
    this.createAt,
  });

  String get fullName => '$firstName $lastName'.trim();

  String get displayRole {
    final clean = role.replaceAll('ROLE_', '').toUpperCase();
    return clean.isEmpty ? 'EMPLOYEE' : clean;
  }

  bool get isActive => status == 'ACT';

  String get initials {
    final firstChar = firstName.isNotEmpty ? firstName[0] : '';
    final lastChar = lastName.isNotEmpty ? lastName[0] : '';
    final res = '$firstChar$lastChar'.toUpperCase();
    return res.isNotEmpty ? res : (username.isNotEmpty ? username[0].toUpperCase() : 'E');
  }

  factory EmployeeModel.fromJson(dynamic json) {
    if (json == null || json is! Map) {
      return EmployeeModel(
        username: '',
        firstName: '',
        lastName: '',
        email: '',
        phoneNumber: '',
      );
    }
    final map = Map<String, dynamic>.from(json);

    String resolvedRole = 'USER';
    if (map['role'] != null) {
      resolvedRole = map['role'].toString();
    } else if (map['roles'] != null && map['roles'] is List && (map['roles'] as List).isNotEmpty) {
      final firstRole = (map['roles'] as List).first;
      if (firstRole is String) {
        resolvedRole = firstRole;
      } else if (firstRole is Map && firstRole['name'] != null) {
        resolvedRole = firstRole['name'].toString();
      }
    }

    return EmployeeModel(
      id: map['id'] is int ? map['id'] : int.tryParse(map['id']?.toString() ?? ''),
      username: map['username']?.toString() ?? '',
      firstName: map['firstName']?.toString() ?? '',
      lastName: map['lastName']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      phoneNumber: map['phoneNumber']?.toString() ?? '',
      role: resolvedRole,
      status: map['status']?.toString() ?? 'ACT',
      profile: map['profile']?.toString(),
      createAt: map['createAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role,
      'status': status,
      if (profile != null) 'profile': profile,
    };
  }

  EmployeeModel copyWith({
    int? id,
    String? username,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? role,
    String? status,
    String? profile,
    String? createAt,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      status: status ?? this.status,
      profile: profile ?? this.profile,
      createAt: createAt ?? this.createAt,
    );
  }
}

