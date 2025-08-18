class BusinessProfile {
  final String name;
  final String phone;
  final String? tin;
  final String? email;
  final String? pincode;
  final String? address;
  final String? businessType;
  final String? category;
  final String? state;
  final String? gst;
  final String? profileImagePath;
  final String? signatureImagePath;
  final String? businessName;
  final String? mobile;

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
    this.businessName,
    this.mobile,
  });

  factory BusinessProfile.fromJson(Map<String, dynamic> json) =>
      BusinessProfile(
        name: json['name'] ?? '',
        phone: json['phone'] ?? '',
        tin: json['tin'],
        email: json['email'],
        pincode: json['pincode'],
        address: json['address'],
        businessType: json['businessType'],
        category: json['category'],
        state: json['state'],
        gst: json['gst'],
        profileImagePath: json['profileImagePath'],
        signatureImagePath: json['signatureImagePath'],
        businessName: json['businessName'],
        mobile: json['mobile'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        'tin': tin,
        'email': email,
        'pincode': pincode,
        'address': address,
        'businessType': businessType,
        'category': category,
        'state': state,
        'gst': gst,
        'profileImagePath': profileImagePath,
        'signatureImagePath': signatureImagePath,
        'businessName': businessName,
        'mobile': mobile,
      };
}
