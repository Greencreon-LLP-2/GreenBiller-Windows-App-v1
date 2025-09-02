import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final bool? loggedIn;

  @HiveField(1)
  final String? accessToken;

  @HiveField(2)
  final String? username;

  @HiveField(3)
  final String? email;

  @HiveField(4)
  final String? phone;

  @HiveField(5)
  final int? userLevel;

  @HiveField(6)
  final String? status;

  @HiveField(7)
  final DateTime? createdAt;

  @HiveField(8)
  final String? licenseKey;

  @HiveField(9)
  final dynamic subscriptionStart;

  @HiveField(10)
  final dynamic subscriptionId;

  @HiveField(11)
  final dynamic subscriptionEnd;

  @HiveField(12)
  final dynamic profileImage;

  @HiveField(13)
  final int? tokenExpiresIn;

  UserModel({
    this.loggedIn,
    this.accessToken,
    this.username,
    this.email,
    this.phone,
    this.userLevel,
    this.status,
    this.createdAt,
    this.licenseKey,
    this.subscriptionStart,
    this.subscriptionId,
    this.subscriptionEnd,
    this.profileImage,
    this.tokenExpiresIn,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    loggedIn: json['status'] is bool ? json['status'] as bool? : null,
    accessToken: json['access_token'] as String?,
    username: json['data']?['name'] as String?,
    email: json['data']?['email'] as String?,
    phone: json['data']?['mobile'] as String?,
    userLevel: json['data']?['user_level'] != null
        ? (json['data']['user_level'] is Map<String, dynamic>
              ? json['data']['user_level']['id']
                    as int? // 👈 pick ID if object
              : (json['data']['user_level'] is String
                    ? int.tryParse(json['data']['user_level'] as String)
                    : json['data']['user_level'] as int?))
        : 4,
    status: json['data']?['status'] as String?,
    createdAt: json['data']?['created_at'] != null
        ? DateTime.tryParse(json['data']['created_at'] as String)
        : null,
    licenseKey: json['data']?['license_key'] as String?,
    subscriptionStart: json['data']?['subcription_start'],
    subscriptionId: json['data']?['subcription_id'],
    subscriptionEnd: json['data']?['subcription_end'],
    profileImage: json['data']?['profile_image'],
    tokenExpiresIn: json['expires_in'] is String
        ? int.tryParse(json['expires_in'] as String) ?? 3600
        : json['expires_in'] as int? ?? 3600,
  );

  Map<String, dynamic> toJson() => {
    'status': loggedIn,
    'access_token': accessToken,
    'data': {
      'name': username,
      'email': email,
      'mobile': phone,
      'user_level': userLevel,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'license_key': licenseKey,
      'subcription_start': subscriptionStart,
      'subcription_id': subscriptionId,
      'subcription_end': subscriptionEnd,
      'profile_image': profileImage,
    },
    'expires_in': tokenExpiresIn,
  };
}
