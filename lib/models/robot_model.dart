class RobotModel {
  final String id;
  final String? currentTableId;
  final String status;
  final DateTime? lastActiveAt;
  final double? batteryPercentage;
  final String? name;
  final String? passwordHash;
  final String? restaurantId;

  RobotModel({
    required this.id,
    this.currentTableId,
    required this.status,
    this.lastActiveAt,
    this.batteryPercentage,
    this.name,
    this.passwordHash,
    this.restaurantId,
  });

  factory RobotModel.fromJson(Map<String, dynamic> json) {
    // Safely extract values with type checking
    String id = '';
    String? currentTableId;
    String status = 'idle'; // Default value
    DateTime? lastActiveAt;
    double? batteryPercentage;
    String? name;
    String? passwordHash;
    String? restaurantId;

    try {
      // Handle required fields with fallbacks
      id = json['id']?.toString() ?? '';
      status = json['status']?.toString() ?? 'idle';

      // Handle optional string fields
      currentTableId = json['current_table_id']?.toString();
      name = json['name']?.toString();
      passwordHash = json['password_hash']?.toString();
      restaurantId = json['restaurant_id']?.toString();

      // Handle datetime parsing safely
      if (json['last_active_at'] != null) {
        try {
          lastActiveAt = DateTime.parse(json['last_active_at'].toString());
        } catch (e) {
          print('Error parsing last_active_at: $e');
        }
      }

      // Handle numeric conversion safely
      if (json['battery_percentage'] != null) {
        try {
          batteryPercentage = (json['battery_percentage'] is num)
              ? (json['battery_percentage'] as num).toDouble()
              : double.tryParse(json['battery_percentage'].toString());
        } catch (e) {
          print('Error parsing battery_percentage: $e');
        }
      }
    } catch (e) {
      print('Error in RobotModel.fromJson: $e');
    }

    return RobotModel(
      id: id,
      currentTableId: currentTableId,
      status: status,
      lastActiveAt: lastActiveAt,
      batteryPercentage: batteryPercentage,
      name: name,
      passwordHash: passwordHash,
      restaurantId: restaurantId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'current_table_id': currentTableId,
      'status': status,
      'last_active_at': lastActiveAt?.toIso8601String(),
      'battery_percentage': batteryPercentage,
      'name': name,
      'password_hash': passwordHash,
      'restaurant_id': restaurantId,
    };
  }
}
