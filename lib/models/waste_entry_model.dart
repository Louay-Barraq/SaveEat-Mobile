class WasteEntryModel {
  final String id;
  final String tableId;
  final String restaurantId;
  final DateTime timestamp;
  final double wasteAmount;
  final String mealTime; // 'breakfast', 'lunch', 'dinner'
  final double? predictedPercentage;
  final String? reportTime;
  final DateTime? createdAt;

  WasteEntryModel({
    required this.id,
    required this.tableId,
    required this.restaurantId,
    required this.timestamp,
    required this.wasteAmount,
    required this.mealTime,
    this.predictedPercentage,
    this.reportTime,
    this.createdAt,
  });

  factory WasteEntryModel.fromJson(Map<String, dynamic> json) {
    // Safely extract values with robust null and type checking
    String id = '';
    String tableId = '';
    String restaurantId = '';
    DateTime timestamp = DateTime.now();
    double wasteAmount = 0.0;
    String mealTime = 'lunch'; // Default value
    double? predictedPercentage;
    String? reportTime;
    DateTime? createdAt;

    try {
      // Handle required fields with fallbacks
      id = json['id']?.toString() ?? '';
      tableId = json['table_id']?.toString() ?? '';
      restaurantId = json['restaurant_id']?.toString() ?? '';

      // Handle timestamp parsing safely
      if (json['timestamp'] != null) {
        try {
          timestamp = DateTime.parse(json['timestamp'].toString());
        } catch (e) {
          print('Error parsing timestamp: $e');
          timestamp = DateTime.now();
        }
      }

      // Handle numeric conversion safely
      if (json['waste_amount'] != null) {
        try {
          wasteAmount = (json['waste_amount'] is num)
              ? (json['waste_amount'] as num).toDouble()
              : double.tryParse(json['waste_amount'].toString()) ?? 0.0;
        } catch (e) {
          print('Error parsing waste_amount: $e');
        }
      }

      // Handle string with null check
      mealTime = json['meal_time']?.toString() ?? 'lunch';

      // Handle optional numeric field
      if (json['predicted_percentage'] != null) {
        try {
          predictedPercentage = (json['predicted_percentage'] is num)
              ? (json['predicted_percentage'] as num).toDouble()
              : double.tryParse(json['predicted_percentage'].toString());
        } catch (e) {
          print('Error parsing predicted_percentage: $e');
        }
      }

      // Handle optional string
      reportTime = json['report_time']?.toString();

      // Handle optional date
      if (json['created_at'] != null) {
        try {
          createdAt = DateTime.parse(json['created_at'].toString());
        } catch (e) {
          print('Error parsing created_at: $e');
        }
      }
    } catch (e) {
      print('Error in WasteEntryModel.fromJson: $e');
    }

    return WasteEntryModel(
      id: id,
      tableId: tableId,
      restaurantId: restaurantId,
      timestamp: timestamp,
      wasteAmount: wasteAmount,
      mealTime: mealTime,
      predictedPercentage: predictedPercentage,
      reportTime: reportTime,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'table_id': tableId,
      'restaurant_id': restaurantId,
      'timestamp': timestamp.toIso8601String(),
      'waste_amount': wasteAmount,
      'meal_time': mealTime,
      'predicted_percentage': predictedPercentage,
      'report_time': reportTime,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  DateTime get localTimestamp => timestamp.toLocal();
}
