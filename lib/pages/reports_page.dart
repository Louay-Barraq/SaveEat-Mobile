import 'package:flutter/material.dart';
import 'package:save_eat/components/day_date_widget.dart';
import 'package:save_eat/components/one_info_widget.dart';
import 'package:save_eat/components/report_infos_widget.dart';
import 'package:save_eat/components/section_indicator_widget.dart';
import 'package:save_eat/services/supabase_service.dart';
import 'package:save_eat/models/waste_entry_model.dart';
import 'package:save_eat/models/table_model.dart';
import 'package:intl/intl.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage>
    with AutomaticKeepAliveClientMixin {
  final SupabaseService _supabaseService = SupabaseService();
  late Stream<List<Map<String, dynamic>>> _todayReportsStream;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _setupReportsStream();
  }

  void _setupReportsStream() {
    try {
      final now = DateTime.now();
      // Set time to exactly midnight for startOfDay
      final startOfDay = DateTime(now.year, now.month, now.day);
      // Set time to 23:59:59 for endOfDay
      final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

      _todayReportsStream = _supabaseService
          .streamTodayWasteEntriesWithTableNumber(startOfDay, endOfDay);

      _errorMessage = null;
    } catch (e) {
      setState(() {
        _errorMessage = 'Error setting up reports stream: $e';
      });
    }
  }

  Future<void> _refreshReports() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Reset the stream to force a refresh
      _setupReportsStream();

      // Wait to allow the stream to initialize
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      setState(() {
        _errorMessage = 'Error refreshing reports: $e';
      });
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
      onRefresh: _refreshReports,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 20),
            DayDateWidget(),
            const SizedBox(height: 20),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Error: $_errorMessage',
                        style: const TextStyle(color: Colors.red)),
                    ElevatedButton(
                      onPressed: _refreshReports,
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              )
            else
              StreamBuilder<List<Map<String, dynamic>>>(
                stream: _todayReportsStream,
                builder: (context, snapshot) {
                  if (_isLoading ||
                      snapshot.connectionState == ConnectionState.waiting &&
                          !snapshot.hasData) {
                    return Container(
                      height: 150,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text('Error loading reports: ${snapshot.error}',
                              style: const TextStyle(color: Colors.red)),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: _refreshReports,
                            child: const Text('Try Again'),
                          ),
                        ],
                      ),
                    );
                  }

                  final reports = snapshot.data ?? [];

                  return Column(
                    children: [
                      OneInfoWidget(
                        title: "Reports Number",
                        percentageValue: 0,
                        timeValue: "",
                        numberValue: reports.length,
                        isPercentage: false,
                        isTime: false,
                      ),
                      const SizedBox(height: 20),
                      SectionIndicatorWidget(
                        title: "Reports List",
                        backgroundColor: Color(0xFFFFFFFF),
                      ),
                      const SizedBox(height: 20),
                      if (reports.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('No reports for today.'),
                        )
                      else
                        ...reports.map((entry) {
                          // Debug print to log the entry structure
                          debugPrint('Report entry: $entry');

                          // Safely extract table number
                          int tableNumber = 0;
                          if (entry['table_model'] != null) {
                            if (entry['table_model'] is Map<String, dynamic>) {
                              final tableModel =
                                  entry['table_model'] as Map<String, dynamic>;
                              if (tableModel.containsKey('table_number')) {
                                tableNumber =
                                    tableModel['table_number'] as int? ?? 0;
                              }
                            }
                          }

                          // Safely extract report time
                          String reportTime = '';
                          if (entry['report_time'] != null) {
                            final reportTimeRaw =
                                entry['report_time'].toString();
                            if (reportTimeRaw.length >= 5) {
                              reportTime = reportTimeRaw.substring(0, 5);
                            }
                          }

                          // Fallback to timestamp if report_time is not available
                          if (reportTime.isEmpty &&
                              entry['timestamp'] != null) {
                            try {
                              final timestamp =
                                  DateTime.parse(entry['timestamp'].toString());
                              reportTime =
                                  DateFormat('HH:mm').format(timestamp);
                            } catch (e) {
                              debugPrint('Error parsing timestamp: $e');
                            }
                          }

                          // Safely extract percentage
                          double percentage = 0.0;
                          if (entry['predicted_percentage'] != null) {
                            try {
                              percentage = entry['predicted_percentage']
                                      is double
                                  ? entry['predicted_percentage']
                                  : double.parse(
                                      entry['predicted_percentage'].toString());
                            } catch (e) {
                              debugPrint(
                                  'Error parsing predicted_percentage: $e');
                            }
                          }

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: ReportInfosWidget(
                              tableNumber: tableNumber,
                              reportTime: reportTime,
                              predictedPercentage: percentage,
                            ),
                          );
                        }),
                      const SizedBox(height: 25),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
