import '../models/waste_entry_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

/// Returns a map with keys 'breakfast', 'lunch', 'dinner' and values as the total waste percentage for each meal time.
Map<String, double> calculateWasteByMealTime(List<WasteEntryModel> entries) {
  final result = {'breakfast': 0.0, 'lunch': 0.0, 'dinner': 0.0};
  for (final entry in entries) {
    if (result.containsKey(entry.mealTime)) {
      result[entry.mealTime] = result[entry.mealTime]! + entry.wasteAmount;
    }
  }
  final total = result.values.fold(0.0, (a, b) => a + b);
  if (total > 0) {
    result.updateAll((key, value) => value / total * 100);
  }
  return result;
}

/// Returns a list of 7 doubles, each representing the total waste for a day of the week (Monday to Sunday).
List<double> calculateWeeklyWaste(List<WasteEntryModel> entries) {
  final List<double> week = List.filled(7, 0.0);
  for (final entry in entries) {
    final weekday = entry.timestamp.weekday - 1; // 0=Mon, 6=Sun
    week[weekday] += entry.wasteAmount;
  }
  return week;
}

/// Returns a list of 4 doubles, each representing the total waste for a week of the month (1st-7th, 8th-14th, etc.).
List<double> calculateMonthlyWaste(List<WasteEntryModel> entries) {
  final List<double> weeks = List.filled(4, 0.0);
  for (final entry in entries) {
    final weekOfMonth = ((entry.timestamp.day - 1) / 7).floor();
    if (weekOfMonth >= 0 && weekOfMonth < 4) {
      weeks[weekOfMonth] += entry.wasteAmount;
    }
  }
  return weeks;
}

/// Returns a map with keys 'breakfast', 'lunch', 'dinner' and values as the total waste percentage for each meal time for a given day.
Map<String, double> calculateWasteByMealTimeForDay(
    List<WasteEntryModel> entries, DateTime day) {
  final result = {'breakfast': 0.0, 'lunch': 0.0, 'dinner': 0.0};
  final filtered = entries.where((e) {
    final local = e.timestamp.toLocal();
    return local.year == day.year &&
        local.month == day.month &&
        local.day == day.day;
  }).toList();
  for (final entry in filtered) {
    if (result.containsKey(entry.mealTime)) {
      result[entry.mealTime] =
          result[entry.mealTime]! + (entry.predictedPercentage ?? 0.0);
    }
  }
  final total = result.values.fold(0.0, (a, b) => a + b);
  if (total > 0) {
    result.updateAll((key, value) => value / total * 100);
  }
  return result;
}

/// Returns the average waste percentage for a given day.
double calculateAverageWasteForDay(
    List<WasteEntryModel> entries, DateTime day) {
  final filtered = entries.where((e) {
    final local = e.timestamp.toLocal();
    return local.year == day.year &&
        local.month == day.month &&
        local.day == day.day;
  }).toList();
  if (filtered.isEmpty) return 0.0;
  final sum = filtered.fold(0.0, (a, b) => a + (b.predictedPercentage ?? 0.0));
  return sum / filtered.length;
}

/// Returns the number of unique tables monitored for a given day.
int calculateUniqueTablesForDay(List<WasteEntryModel> entries, DateTime day) {
  final filtered = entries.where((e) {
    final local = e.timestamp.toLocal();
    return local.year == day.year &&
        local.month == day.month &&
        local.day == day.day;
  }).toList();
  final uniqueTables = filtered.map((e) => e.tableId).toSet();
  return uniqueTables.length;
}

/// Returns a list of 7 averages and a list of 7 day labels for the last 7 days (rolling, not Mon-Sun).
Map<String, List> calculateWeeklyAveragesAndLabels(
    List<WasteEntryModel> entries,
    {DateTime? referenceDate}) {
  final now = referenceDate ?? DateTime.now();
  List<double> averages = [];
  List<String> labels = [];

  try {
    for (int i = 6; i >= 0; i--) {
      final day = now.subtract(Duration(days: i));
      averages.add(calculateAverageWasteForDay(entries, day));
      // Make sure we have valid strings for labels
      String label = '';
      try {
        label = DateFormat('EEE').format(day);
      } catch (e) {
        // Fallback if DateFormat fails
        label = 'Day${6 - i}';
      }
      labels.add(label);
    }
  } catch (e) {
    // If any error occurs, ensure we still return valid data
    debugPrint('Error in calculateWeeklyAveragesAndLabels: $e');
    averages = List<double>.filled(7, 0.0);
    labels = List<String>.generate(7, (i) => 'Day$i');
  }

  // Ensure lists are the correct length
  if (averages.length != 7) {
    averages = List<double>.filled(7, 0.0);
  }

  if (labels.length != 7) {
    labels = List<String>.generate(7, (i) => 'Day$i');
  }

  return {'averages': averages, 'labels': labels};
}

/// Returns a list of 4 averages for the last 4 weeks (each week is 7 days, rolling from today).
List<double> calculateMonthlyAverages(List<WasteEntryModel> entries,
    {DateTime? referenceDate}) {
  final now = referenceDate ?? DateTime.now();
  List<double> averages = [];
  for (int w = 3; w >= 0; w--) {
    final weekStart = now.subtract(Duration(days: (w + 1) * 7 - 1));
    final weekEnd = now.subtract(Duration(days: w * 7));
    final weekEntries = entries
        .where((e) =>
            e.timestamp.isAfter(weekStart.subtract(const Duration(days: 1))) &&
            e.timestamp.isBefore(weekEnd.add(const Duration(days: 1))))
        .toList();
    if (weekEntries.isEmpty) {
      averages.add(0.0);
    } else {
      final sum =
          weekEntries.fold(0.0, (a, b) => a + (b.predictedPercentage ?? 0.0));
      averages.add(sum / weekEntries.length);
    }
  }
  return averages;
}
