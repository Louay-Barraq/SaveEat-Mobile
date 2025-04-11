import 'package:flutter/material.dart';
import 'package:save_eat/components/action_button_widget.dart';
import 'package:save_eat/components/dashboard_stats_widget.dart';
import 'package:save_eat/components/day_date_widget.dart';
import 'package:save_eat/components/one_info_widget.dart';
import 'package:save_eat/components/section_indicator_widget.dart';


class RobotPage extends StatefulWidget {
  const RobotPage({super.key});

  @override
  State<RobotPage> createState() => _RobotPageState();
}

class _RobotPageState extends State<RobotPage>
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

          // RobotNameWidget(),

          // const SizedBox(height: 20),

          SectionIndicatorWidget(
            title: "Informations",
            backgroundColor: Color(0xFFFFFFFF),
          ),

          const SizedBox(height: 20),

          OneInfoWidget(
            title: "Monitored Tables",
            percentageValue: 0.48,
            timeValue: '',
            numberValue: 0,
            isPercentage: true,
            isTime: false,
          ),

          const SizedBox(height: 20),

          OneInfoWidget(
            title: "Active Since",
            percentageValue: 0,
            timeValue: '08:40',
            numberValue: 0,
            isPercentage: false,
            isTime: true,
          ),

          const SizedBox(height: 20),

          SectionIndicatorWidget(
            title: "Actions",
            backgroundColor: Color(0xFFFFFFFF),
          ),

          const SizedBox(height: 20),

          ActionButtonWidget(title: "Return To Station"),

          const SizedBox(height: 25),

        ],
      ),
    );
  }
}

class RobotNameWidget extends StatelessWidget {
  const RobotNameWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 4,
            spreadRadius: 2,
            color: Color(0x3F000000),
          ),
        ],
      ),
      child: Center(
        child: Text(
          "Robot 1",
          style: const TextStyle(
            fontFamily: 'Inconsolata',
            fontWeight: FontWeight.w500,
            fontSize: 30,
          ),
        ),
      ),
    );
  }
}