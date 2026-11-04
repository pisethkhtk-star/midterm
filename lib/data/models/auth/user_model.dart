class UserModel {
  final int? id;
  final String? username;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final String? status;
  final String? profile;
  final List<String> roles;
  final String? createAt;

  UserModel({
    this.id,
    this.username,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.status,
    this.profile,
    this.roles = const [],
    this.createAt,
  });

  String get fullName {
    final first = firstName ?? '';
    final last = lastName ?? '';
    final full = '$first $last'.trim();
    return full.isNotEmpty ? full : (username ?? 'User');
  }

  String get initials {
    if (firstName != null && firstName!.isNotEmpty && lastName != null && lastName!.isNotEmpty) {
      return '${firstName![0]}${lastName![0]}'.toUpperCase();
    }
    if (fullName.isNotEmpty) {
      return fullName[0].toUpperCase();
    }
    return 'U';
  }

  bool get isAdmin => roles.any((r) => r.toUpperCase().contains('ADMIN'));

  factory UserModel.fromJson(dynamic json) {
    if (json == null || json is! Map) {
      return UserModel();
    }
    final map = Map<String, dynamic>.from(json);

    List<String> parsedRoles = [];
    if (map['roles'] != null) {
      if (map['roles'] is List) {
        for (var r in (map['roles'] as List)) {
          if (r is String) {
            parsedRoles.add(r);
          } else if (r is Map && r['name'] != null) {
            parsedRoles.add(r['name'].toString());
          }
        }
      } else if (map['roles'] is String) {
        parsedRoles.add(map['roles']);
      }
    }
    if (map['role'] != null && map['role'] is String) {
      parsedRoles.add(map['role']);
    }

    return UserModel(
      id: map['id'] is int ? map['id'] : int.tryParse(map['id']?.toString() ?? ''),
      username: map['username']?.toString(),
      firstName: map['firstName']?.toString(),
      lastName: map['lastName']?.toString(),
      email: map['email']?.toString(),
      phoneNumber: map['phoneNumber']?.toString(),
      status: map['status']?.toString() ?? 'ACT',
      profile: map['profile']?.toString(),
      roles: parsedRoles,
      createAt: map['createAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'status': status,
      'profile': profile,
      'roles': roles,
      'createAt': createAt,
    };
  }
}

