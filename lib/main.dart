import 'package:flutter/material.dart';
import 'package:save_eat/pages/dashboard_page.dart';
import 'package:save_eat/pages/reports_page.dart';
import 'package:save_eat/pages/robot_page.dart';
import 'package:save_eat/pages/settings_page.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SaveEat',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainWrapper(),
    );
  }
}

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    const DashboardPage(),
    const RobotPage(),
    const ReportsPage(),
    const SettingsPage(),
  ];

  final List<String> _appBarTitles = [
    'DASHBOARD',
    'ROBOT',
    'REPORTS',
    'SETTINGS'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE9E9E9),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        elevation: 0.5,
        shadowColor: Color(0x3F000000),
        title: Text(
          _appBarTitles[_currentIndex],
          style: const TextStyle(
            letterSpacing: 4,
            fontFamily: "Inconsolata",
            fontWeight: FontWeight.w500,
            fontSize: 30,
            shadows: [
              Shadow(
                color: Colors.grey,
                offset: Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: PageView(
        controller: _pageController,
        physics: const BouncingScrollPhysics(), // Enable swipe
        onPageChanged: (index) => setState(() => _currentIndex = index),
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: const Color(0xFF505050),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(
          fontFamily: "Inconsolata",
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: "Inconsolata",
          fontWeight: FontWeight.w300,
        ),
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/dashboard.png',
              width: 24,
              height: 24,
              color: const Color(0xFF505050),
            ),
            activeIcon: Image.asset(
              'assets/icons/dashboard.png',
              width: 24,
              height: 24,
              color: Colors.black,
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
                'assets/icons/robot.png',
                width: 24,
                height: 24,
                color: const Color(0xFF505050)),
            activeIcon: Image.asset(
              'assets/icons/robot.png',
              width: 24,
              height: 24,
              color: Colors.black,
            ),
            label: 'Robot',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
                'assets/icons/reports.png',
                width: 24,
                height: 24,
                color: const Color(0xFF505050)),
            activeIcon: Image.asset(
              'assets/icons/reports.png',
              width: 24,
              height: 24,
              color: Colors.black,
            ),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
                'assets/icons/settings.png',
                width: 24,
                height: 24,
                color: const Color(0xFF505050)),
            activeIcon: Image.asset(
              'assets/icons/settings.png',
              width: 24,
              height: 24,
              color: Colors.black,
            ),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}