// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:save_eat/components/dashboard_stats_widget.dart';
import 'package:save_eat/components/day_date_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:save_eat/components/monthly_chart_widget.dart';
import 'package:save_eat/components/waste_by_time_pie_chart_widget.dart';
import 'package:save_eat/components/weekly_chart_widget.dart';
import 'package:save_eat/services/supabase_service.dart';
import 'package:save_eat/utils/statistics_utils.dart';
import 'package:save_eat/models/waste_entry_model.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with AutomaticKeepAliveClientMixin {
  final SupabaseService _supabaseService = SupabaseService();
  late Future<List<WasteEntryModel>> _wasteEntriesFuture;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchWasteEntries();
  }

  Future<void> _fetchWasteEntries() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Fetch last 31 days using local time range converted to UTC
      final nowLocal = DateTime.now();
      final start31DaysAgoLocal =
          DateTime(nowLocal.year, nowLocal.month, nowLocal.day)
              .subtract(const Duration(days: 30));
      final endOfTodayLocal =
          DateTime(nowLocal.year, nowLocal.month, nowLocal.day)
              .add(const Duration(days: 1))
              .subtract(const Duration(seconds: 1));
      final startUtc = start31DaysAgoLocal.toUtc();
      final endUtc = endOfTodayLocal.toUtc();

      _wasteEntriesFuture =
          SupabaseService().fetchWasteEntries(from: startUtc, to: endUtc);

      // Pre-fetch the data to catch any errors immediately
      try {
        await _wasteEntriesFuture;
      } catch (e) {
        debugPrint('Error pre-fetching waste entries: $e');
        _errorMessage = 'Failed to load data: $e';
      }
    } catch (e) {
      debugPrint('Error in _fetchWasteEntries: $e');
      _errorMessage = 'Error preparing data fetch: $e';
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return RefreshIndicator(
      onRefresh: () async {
        await _fetchWasteEntries();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 20),
            DayDateWidget(),
            const SizedBox(height: 20),

            // Show error message if any
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Error: $_errorMessage',
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _fetchWasteEntries,
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),

            FutureBuilder<List<WasteEntryModel>>(
              future: _wasteEntriesFuture,
              builder: (context, snapshot) {
                if (_isLoading ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                      height: 200,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  // Log detailed error
                  debugPrint('Dashboard error: ${snapshot.error}');
                  if (snapshot.error is Error) {
                    debugPrint(
                        'Stack trace: ${(snapshot.error as Error).stackTrace}');
                  }

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text('Error loading dashboard data: ${snapshot.error}'),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: _fetchWasteEntries,
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                }

                // Safe data access - create a non-null list
                final entries = snapshot.data ?? [];

                // Show message if there's no data
                if (entries.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No waste entries found for this period.'),
                  );
                }

                // Process data in a try-catch block to catch any unexpected errors
                try {
                  // Use local today and yesterday
                  final now = DateTime.now();
                  final today = DateTime(now.year, now.month, now.day);
                  final yesterday = today.subtract(const Duration(days: 1));

                  // Today's and yesterday's waste averages
                  final todayAvg = calculateAverageWasteForDay(entries, today);
                  final yesterdayAvg =
                      calculateAverageWasteForDay(entries, yesterday);

                  // Monitored tables
                  final todayTables =
                      calculateUniqueTablesForDay(entries, today);
                  final yesterdayTables =
                      calculateUniqueTablesForDay(entries, yesterday);

                  // Weekly chart - with explicit handling of nulls
                  Map<String, List> weekly;
                  try {
                    weekly = calculateWeeklyAveragesAndLabels(entries,
                        referenceDate: today);
                  } catch (e) {
                    debugPrint('Error calculating weekly data: $e');
                    weekly = {
                      'averages': List<double>.filled(7, 0.0),
                      'labels': List<String>.filled(7, '')
                    };
                  }

                  final List<double> weeklyAverages =
                      (weekly['averages'] is List<double>)
                          ? (weekly['averages'] as List<double>)
                              .map((v) => v * 100)
                              .toList()
                          : List<double>.filled(7, 0.0);

                  final List<String> weeklyLabels =
                      (weekly['labels'] is List<String>)
                          ? weekly['labels'] as List<String>
                          : List<String>.generate(7, (i) => 'Day $i');

                  // Monthly chart - with safe handling
                  List<double> monthlyAverages;
                  try {
                    monthlyAverages =
                        calculateMonthlyAverages(entries, referenceDate: today)
                            .map((v) => v * 100)
                            .toList();
                  } catch (e) {
                    debugPrint('Error calculating monthly averages: $e');
                    monthlyAverages = List<double>.filled(4, 0.0);
                  }

                  // Ensure monthlyAverages has exactly 4 entries as expected by the chart
                  if (monthlyAverages.length < 4) {
                    final paddedList = List<double>.filled(4, 0.0);
                    for (int i = 0; i < monthlyAverages.length; i++) {
                      paddedList[i] = monthlyAverages[i];
                    }
                    monthlyAverages = paddedList;
                  } else if (monthlyAverages.length > 4) {
                    monthlyAverages = monthlyAverages.sublist(0, 4);
                  }

                  // Waste by time of day (today)
                  final wasteByTime =
                      calculateWasteByMealTimeForDay(entries, today);

                  return Column(
                    children: [
                      DashboardStatsWidget(
                        title: "Today's Waste",
                        primaryValue: todayAvg,
                        comparisonValue: todayAvg - yesterdayAvg,
                        isPercentage: true,
                      ),
                      const SizedBox(height: 20),
                      DashboardStatsWidget(
                        title: "Monitored Tables",
                        primaryValue: todayTables.toDouble(),
                        comparisonValue:
                            todayTables.toDouble() - yesterdayTables.toDouble(),
                        isPercentage: false,
                      ),
                      const SizedBox(height: 20),
                      WeeklyWasteChart(
                        weeklyData: weeklyAverages,
                        labels: weeklyLabels,
                      ),
                      const SizedBox(height: 20),
                      MonthlyWasteChart(
                        weeklyData: monthlyAverages,
                      ),
                      const SizedBox(height: 20),
                      WasteTimePieChart(
                        breakfastValue: wasteByTime['breakfast'] ?? 0.0,
                        lunchValue: wasteByTime['lunch'] ?? 0.0,
                        dinnerValue: wasteByTime['dinner'] ?? 0.0,
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                } catch (e, stackTrace) {
                  // Catch any other errors in processing data
                  debugPrint('Unexpected error in dashboard: $e');
                  debugPrint('Stack trace: $stackTrace');
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text('Error processing data: $e'),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: _fetchWasteEntries,
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
