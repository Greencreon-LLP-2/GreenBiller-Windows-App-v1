import 'package:hive/hive.dart';

part 'business_profile_model.g.dart';

@HiveType(typeId: 1)
class BusinessProfile {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String phone;

  @HiveField(2)
  final String? tin;

  @HiveField(3)
  final String? email;

  @HiveField(4)
  final String? pincode;

  @HiveField(5)
  final String? address;

  @HiveField(6)
  final String? businessType;

  @HiveField(7)
  final String? category;

  @HiveField(8)
  final String? state;

  @HiveField(9)
  final String? gst;

  @HiveField(10)
  final String? profileImagePath;

  @HiveField(11)
  final String? signatureImagePath;

  @HiveField(12)
  final int? id;

  BusinessProfile({
    required this.name,
    required this.phone,
    this.tin,
    this.email,
    this.pincode,
    this.address,
    this.businessType,
    this.category,
    this.state,
    this.gst,
    this.profileImagePath,
    this.signatureImagePath,
    this.id,
  });

  factory BusinessProfile.fromJson(Map<String, dynamic> json) =>
      BusinessProfile(
        name: json['bussiness_name'] ?? '',
        phone: json['phone'] ?? '',
        tin: json['tin'],
        email: json['email'],
        pincode: json['pincode'],
        address: json['address'],
        businessType: json['business_type'],
        category: json['category'],
        state: json['state'],
        gst: json['gst'],
        id: json['id'],
        profileImagePath: json['profileImagePath'],
        signatureImagePath: json['signatureImagePath'],
      );

  Map<String, dynamic> toJson() => {
    'name': name,
    'phone': phone,
    if (id != null) 'id': id,
    if (tin != null) 'tin': tin,
    if (email != null) 'email': email,
    if (pincode != null) 'pincode': pincode,
    if (address != null) 'address': address,
    if (businessType != null) 'business_type': businessType,
    if (category != null) 'category': category,
    if (state != null) 'state': state,
    if (gst != null) 'gst': gst,
    if (profileImagePath != null) 'profileImagePath': profileImagePath,
    if (signatureImagePath != null) 'signatureImagePath': signatureImagePath,
  };
}
