class UserModel {
  final String id;
  final String email;
  final String role; // 'admin', 'staff', etc.
  final String restaurantId;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    required this.restaurantId,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Safely extract values with type checking
    String id = '';
    String email = '';
    String role = 'user'; // Default role
    String restaurantId = '';
    DateTime? createdAt;

    try {
      // Handle required fields with fallbacks
      id = json['id']?.toString() ?? '';
      email = json['email']?.toString() ?? '';
      role = json['role']?.toString() ?? 'user';
      restaurantId = json['restaurant_id']?.toString() ?? '';

      // Handle datetime parsing safely
      if (json['created_at'] != null) {
        try {
          createdAt = DateTime.parse(json['created_at'].toString());
        } catch (e) {
          print('Error parsing created_at in UserModel: $e');
        }
      }
    } catch (e) {
      print('Error in UserModel.fromJson: $e');
    }

    return UserModel(
      id: id,
      email: email,
      role: role,
      restaurantId: restaurantId,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role,
      'restaurant_id': restaurantId,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
