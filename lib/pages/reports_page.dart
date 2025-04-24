import 'package:flutter/material.dart';
import 'package:save_eat/components/day_date_widget.dart';
import 'package:save_eat/components/one_info_widget.dart';
import 'package:save_eat/components/report_infos_widget.dart';
import 'package:save_eat/components/section_indicator_widget.dart';


class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage>
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

          OneInfoWidget(
            title: "Reports Number",
            percentageValue: 0, timeValue: "",
            numberValue: 7,
            isPercentage: false,
            isTime: false,
          ),

          const SizedBox(height: 20),

          SectionIndicatorWidget(
            title: "Reports List",
            backgroundColor: Color(0xFFFFFFFF),
          ),

          const SizedBox(height: 20),

          ReportInfosWidget(
            tableNumber: 9,
            reportTime: "20:15",
            predictedPercentage: 0.07,
          ),

          const SizedBox(height: 20),

          ReportInfosWidget(
            tableNumber: 15,
            reportTime: "19:45",
            predictedPercentage: 0.88,
          ),

          const SizedBox(height: 20),

          ReportInfosWidget(
            tableNumber: 2,
            reportTime: "18:13",
            predictedPercentage: 0.26,
          ),

          const SizedBox(height: 25),

        ],
      ),
    );
  }
}