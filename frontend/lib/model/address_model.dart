class Address {
  final int id;
  final int userId;
  final String recipientName;
  final String phoneNumber;
  final String addressLine1;
  final String city;
  final String state;
  final String postalCode;
  final bool isDefault;

  Address({
    required this.id,
    required this.userId,
    required this.recipientName,
    required this.phoneNumber,
    required this.addressLine1,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.isDefault,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      userId: json['user_id'],
      recipientName: json['recipient_name'],
      phoneNumber: json['phone_number'],
      addressLine1: json['address_line_1'],
      city: json['city'],
      state: json['state'],
      postalCode: json['postal_code'],
      isDefault: json['is_default'],
    );
  }
}

class SupportedArea {
  final String city;
  final String state;

  SupportedArea({
    required this.city,
    required this.state,
  });

  // Factory method untuk membuat objek SupportedArea dari JSON
  factory SupportedArea.fromJson(Map<String, dynamic> json) {
    return SupportedArea(
      city: json['city'],
      state: json['state'],
    );
  }

  // Mengubah objek SupportedArea menjadi format JSON
  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'state': state,
    };
  }
}
