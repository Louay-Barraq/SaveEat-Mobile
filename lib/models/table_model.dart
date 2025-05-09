class TableModel {
  final String id;
  final String restaurantId;
  final String tableNumber;
  final DateTime? createdAt;

  TableModel({
    required this.id,
    required this.restaurantId,
    required this.tableNumber,
    this.createdAt,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) {
    // Safely extract values with type checking
    String id = '';
    String restaurantId = '';
    String tableNumber = '';
    DateTime? createdAt;

    try {
      // Handle required fields with fallbacks
      id = json['id']?.toString() ?? '';
      restaurantId = json['restaurant_id']?.toString() ?? '';

      // Handle table_number which might be an int or string
      if (json['table_number'] != null) {
        tableNumber = json['table_number'].toString();
      }

      // Handle datetime parsing safely
      if (json['created_at'] != null) {
        try {
          createdAt = DateTime.parse(json['created_at'].toString());
        } catch (e) {
          print('Error parsing created_at in TableModel: $e');
        }
      }
    } catch (e) {
      print('Error in TableModel.fromJson: $e');
    }

    return TableModel(
      id: id,
      restaurantId: restaurantId,
      tableNumber: tableNumber,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurant_id': restaurantId,
      'table_number': tableNumber,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
