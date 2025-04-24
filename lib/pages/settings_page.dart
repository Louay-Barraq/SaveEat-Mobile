import 'package:flutter/material.dart';
import 'package:save_eat/components/action_button_widget.dart';
import 'package:save_eat/components/day_date_widget.dart';
import 'package:save_eat/components/section_indicator_widget.dart';
import 'package:save_eat/components/toggle_switch_component_widget.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
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

          SectionIndicatorWidget(
            title: "General",
            backgroundColor: Color(0xFFD9D9D9),
          ),

          const SizedBox(height: 20),
          
          ToggleSwitchComponentWidget(title: "Notifications"),
          
          const SizedBox(height: 20),

          ToggleSwitchComponentWidget(title: "Dark Theme"),
          
          const SizedBox(height: 20),

          SectionIndicatorWidget(
            title: "Account",
            backgroundColor: Color(0xFFD9D9D9),
          ),

          const SizedBox(height: 20),

          ActionButtonWidget(
            title: "Account Settings",
            onPressed: () {
              // Action à exécuter lorsque le bouton est pressé
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account Settings pressed')),
              );
            },
          ),

          const SizedBox(height: 20),

          ActionButtonWidget(
            title: "Reports Settings",
            onPressed: () {
              // Action à exécuter lorsque le bouton est pressé
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Reports Settings pressed')),
              );
            },
          ),

        ],
      ),
    );
  }
}