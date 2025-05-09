import 'dart:async';
import 'package:flutter/material.dart';
import 'package:save_eat/components/action_button_widget.dart';
import 'package:save_eat/components/day_date_widget.dart';
import 'package:save_eat/components/one_info_widget.dart';
import 'package:save_eat/components/section_indicator_widget.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class RobotPage extends StatefulWidget {
  const RobotPage({super.key});

  @override
  State<RobotPage> createState() => _RobotPageState();
}

class _RobotPageState extends State<RobotPage>
    with AutomaticKeepAliveClientMixin {
  // Removed periodic timer to reduce API calls

  @override
  void initState() {
    super.initState();
    // No timer initialization - only refresh on user action
  }

  Future<void> _refreshRobotData() async {
    // Always refresh on manual pull down
    await Provider.of<AuthProvider>(context, listen: false).refreshRobot();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final robot = Provider.of<AuthProvider>(context).robot;
    return RefreshIndicator(
      onRefresh: _refreshRobotData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 20),
            DayDateWidget(),
            const SizedBox(height: 20),
            if (robot != null) ...[
              Container(
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
                    robot.name ?? 'Robot',
                    style: const TextStyle(
                      fontFamily: 'Inconsolata',
                      fontWeight: FontWeight.w500,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SectionIndicatorWidget(
                title: "Informations",
                backgroundColor: Color(0xFFFFFFFF),
              ),
              const SizedBox(height: 20),
              OneInfoWidget(
                title: "Battery Percentage",
                percentageValue: (robot.batteryPercentage ?? 0) / 100.0,
                timeValue: '',
                numberValue: 0,
                isPercentage: true,
                isTime: false,
              ),
              const SizedBox(height: 20),
              OneInfoWidget(
                title: "Active Since",
                percentageValue: 0,
                timeValue: robot.lastActiveAt != null
                    ? TimeOfDay.fromDateTime(robot.lastActiveAt!)
                        .format(context)
                    : '--:--',
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
              ActionButtonWidget(
                title: "Return To Station",
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Robot is returning to station')),
                  );
                },
              ),
              const SizedBox(height: 25),
            ] else ...[
              const Padding(
                padding: EdgeInsets.all(24.0),
                child: Text('No robot authenticated.'),
              ),
            ],
          ],
        ),
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
