class RestaurantModel {
  final String id;
  final String name;
  final String? location;
  final DateTime? createdAt;

  RestaurantModel({
    required this.id,
    required this.name,
    this.location,
    this.createdAt,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    // Safely extract values with type checking
    String id = '';
    String name = '';
    String? location;
    DateTime? createdAt;

    try {
      // Handle required fields with fallbacks
      id = json['id']?.toString() ?? '';
      name = json['name']?.toString() ?? '';

      // Handle optional fields
      location = json['location']?.toString();

      // Handle datetime parsing safely
      if (json['created_at'] != null) {
        try {
          createdAt = DateTime.parse(json['created_at'].toString());
        } catch (e) {
          print('Error parsing created_at in RestaurantModel: $e');
        }
      }
    } catch (e) {
      print('Error in RestaurantModel.fromJson: $e');
    }

    return RestaurantModel(
      id: id,
      name: name,
      location: location,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
