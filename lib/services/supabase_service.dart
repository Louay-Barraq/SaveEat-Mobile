import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/table_model.dart';
import '../models/robot_model.dart';
import '../models/restaurant_model.dart';
import '../models/waste_entry_model.dart';
import '../models/user_model.dart';

class SupabaseService {
  final _client = Supabase.instance.client;

  // Restaurant
  Future<List<RestaurantModel>> fetchRestaurants() async {
    final response = await _client.from('restaurant').select();
    final data = response as List;
    return data.map((json) => RestaurantModel.fromJson(json)).toList();
  }

  // Table
  Future<List<TableModel>> fetchTables(String restaurantId) async {
    final response = await _client
        .from('table_model')
        .select()
        .eq('restaurant_id', restaurantId);
    final data = response as List;
    return data.map((json) => TableModel.fromJson(json)).toList();
  }

  // Waste Entries (for stats, charts, reports)
  Future<List<WasteEntryModel>> fetchWasteEntries(
      {String? tableId,
      String? restaurantId,
      DateTime? from,
      DateTime? to}) async {
    var query = _client.from('waste_entry').select();
    if (tableId != null) query = query.eq('table_id', tableId);
    if (restaurantId != null) query = query.eq('restaurant_id', restaurantId);
    if (from != null) query = query.gte('timestamp', from.toIso8601String());
    if (to != null) query = query.lte('timestamp', to.toIso8601String());
    final response = await query;
    final data = response as List;
    return data.map((json) => WasteEntryModel.fromJson(json)).toList();
  }

  // Fetch waste entries for today (local time, but query in UTC)
  Future<List<WasteEntryModel>> fetchTodayWasteEntries() async {
    final nowLocal = DateTime.now();
    final startOfDayLocal =
        DateTime(nowLocal.year, nowLocal.month, nowLocal.day);
    final endOfDayLocal = startOfDayLocal
        .add(const Duration(days: 1))
        .subtract(const Duration(seconds: 1));
    final startOfDayUtc = startOfDayLocal.toUtc();
    final endOfDayUtc = endOfDayLocal.toUtc();
    final response = await _client
        .from('waste_entry')
        .select()
        .gte('timestamp', startOfDayUtc.toIso8601String())
        .lte('timestamp', endOfDayUtc.toIso8601String());
    final data = response as List;
    return data.map((json) => WasteEntryModel.fromJson(json)).toList();
  }

  // Insert a new waste entry (always store timestamp in UTC)
  Future<void> insertWasteEntry(WasteEntryModel entry) async {
    final entryUtc = WasteEntryModel(
      id: entry.id,
      tableId: entry.tableId,
      restaurantId: entry.restaurantId,
      timestamp: entry.timestamp.toUtc(),
      wasteAmount: entry.wasteAmount,
      mealTime: entry.mealTime,
      predictedPercentage: entry.predictedPercentage,
      reportTime: entry.reportTime,
      createdAt: entry.createdAt?.toUtc(),
    );
    await _client.from('waste_entry').insert(entryUtc.toJson());
  }

  // Users
  Future<List<UserModel>> fetchUsers({String? restaurantId}) async {
    var query = _client.from('app_user').select();
    if (restaurantId != null) query = query.eq('restaurant_id', restaurantId);
    final response = await query;
    final data = response as List;
    return data.map((json) => UserModel.fromJson(json)).toList();
  }

  // Robot
  Future<List<RobotModel>> fetchRobots() async {
    final response = await _client.from('robot_model').select();
    final data = response as List;
    return data.map((json) => RobotModel.fromJson(json)).toList();
  }

  // Update robot status (e.g., after summoning or returning to station)
  Future<void> updateRobotStatus(String robotId,
      {String? status,
      double? batteryPercentage,
      DateTime? lastActiveAt,
      String? currentTableId}) async {
    final updateData = <String, dynamic>{};
    if (status != null) updateData['status'] = status;
    if (batteryPercentage != null) {
      updateData['battery_percentage'] = batteryPercentage;
    }
    if (lastActiveAt != null) {
      updateData['last_active_at'] = lastActiveAt.toIso8601String();
    }
    if (currentTableId != null) updateData['current_table_id'] = currentTableId;
    await _client.from('robot_model').update(updateData).eq('id', robotId);
  }

  // Fetch today's waste entries with table number (using join)
  Future<List<Map<String, dynamic>>> fetchTodayWasteEntriesWithTableNumber(
      DateTime startOfDay, DateTime endOfDay) async {
    final response = await _client
        .from('waste_entry')
        .select(
            'id, report_time, predicted_percentage, timestamp, table_model(table_number)')
        .gte('timestamp', startOfDay.toIso8601String())
        .lte('timestamp', endOfDay.toIso8601String());
    return (response as List).cast<Map<String, dynamic>>();
  }

  // Stream of today's waste entries for real-time updates with table number
  Stream<List<Map<String, dynamic>>> streamTodayWasteEntriesWithTableNumber(
      DateTime startOfDay, DateTime endOfDay) {
    // Convert dates to UTC for consistent querying
    final startUtc = startOfDay.toUtc();
    final endUtc = endOfDay.toUtc();

    // Create a stream that polls the database every 3 seconds
    return Stream.periodic(const Duration(seconds: 3), (_) async {
      try {
        // Directly query using timestamps rather than date casting
        final response = await _client
            .from('waste_entry')
            .select(
                'id, report_time, predicted_percentage, timestamp, table_model(table_number)')
            .gte('timestamp', startUtc.toIso8601String())
            .lte('timestamp', endUtc.toIso8601String())
            .order('timestamp', ascending: false);

        if (response == null) return <Map<String, dynamic>>[];

        // Ensure we're returning a properly typed list
        final typedResponse = (response as List).cast<Map<String, dynamic>>();

        return typedResponse;
      } catch (e) {
        print('Error fetching today\'s waste entries: $e');
        return <Map<String, dynamic>>[];
      }
    }).asyncMap((event) => event);
  }

  // Fetch all waste entries for the last 31 days
  Future<List<WasteEntryModel>> fetchWasteEntriesLast31Days() async {
    final now = DateTime.now();
    final from = now.subtract(const Duration(days: 30));
    final response = await _client
        .from('waste_entry')
        .select()
        .gte('timestamp', from.toIso8601String())
        .lte('timestamp', now.toIso8601String());
    final data = response as List;
    return data.map((json) => WasteEntryModel.fromJson(json)).toList();
  }

  // Authenticate robot by name and password hash
  Future<RobotModel?> authenticateRobot(
      String name, String passwordHash) async {
    final response = await _client
        .from('robot_model')
        .select()
        .eq('name', name)
        .eq('password_hash', passwordHash)
        .maybeSingle();
    if (response == null) return null;
    return RobotModel.fromJson(response as Map<String, dynamic>);
  }

  // Add more methods as needed for reports, statistics, etc.
}
