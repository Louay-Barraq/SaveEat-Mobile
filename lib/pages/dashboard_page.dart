// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:save_eat/components/dashboard_stats_widget.dart';
import 'package:save_eat/components/day_date_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:save_eat/components/monthly_chart_widget.dart';
import 'package:save_eat/components/waste_by_time_pie_chart_widget.dart';
import 'package:save_eat/components/weekly_chart_widget.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with AutomaticKeepAliveClientMixin {
  // Add the mixin

  @override
  bool get wantKeepAlive => true; // Required override for preservation

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
        child: Column(
            children: [
            const SizedBox(height: 20),

            DayDateWidget(),

            const SizedBox(height: 20),

            DashboardStatsWidget(
              title: "Today's Waste",
              primaryValue: 0.32,
              comparisonValue: 0.2,
              isPercentage: true,
            ),

            const SizedBox(height: 20),

            DashboardStatsWidget(
              title: "Monitored Tables",
              primaryValue: 24,
              comparisonValue: 23,
              isPercentage: false,
            ),

            const SizedBox(height: 20),

            WeeklyWasteChart(
              weeklyData: [20, 90, 50, 10, 80, 95, 60],
            ),

            const SizedBox(height: 20),

            MonthlyWasteChart(
              weeklyData: [90, 45, 60, 35],
            ),

            const SizedBox(
              height: 20,
            ),

            WasteTimePieChart(
              breakfastValue: 35,
              lunchValue: 45,
              dinnerValue: 20,
            ),

            const SizedBox(
              height: 20,
            ),
    ]));
  }
}
