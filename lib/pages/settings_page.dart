import 'package:flutter/material.dart';
import 'package:save_eat/components/action_button_widget.dart';
import 'package:save_eat/components/day_date_widget.dart';
import 'package:save_eat/components/section_indicator_widget.dart';
import 'package:save_eat/components/toggle_switch_component_widget.dart';
import 'package:provider/provider.dart';
import '../../main.dart';

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
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {}); // If you fetch data, refetch here
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: SingleChildScrollView(
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
            const SizedBox(height: 20),
            ActionButtonWidget(
              title: "Disconnect",
              onPressed: () {
                Provider.of<AuthProvider>(context, listen: false).logout();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'Logged out successfully',
                      style: TextStyle(color: Colors.white, fontSize: 17.0),
                    ),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
