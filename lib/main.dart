import 'package:flutter/material.dart';
import 'package:save_eat/pages/dashboard_page.dart';
import 'package:save_eat/pages/qr_scan_page.dart';
import 'package:save_eat/pages/reports_page.dart';
import 'package:save_eat/pages/robot_page.dart';
import 'package:save_eat/pages/settings_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'models/robot_model.dart';
import 'services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://hzbesrpxlldozjzeahwl.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh6YmVzcnB4bGxkb3pqemVhaHdsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDY3MTA4MzcsImV4cCI6MjA2MjI4NjgzN30.lQk4fSIWzF_rauI-TW1xV9U0bZi8TvwHdFHnSdSy7vc',
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: const MyApp(),
    ),
  );
}

class AuthProvider extends ChangeNotifier {
  RobotModel? _robot;
  RobotModel? get robot => _robot;
  bool get isAuthenticated => _robot != null;

  Future<bool> login(String name, String passwordHash) async {
    final robot = await SupabaseService().authenticateRobot(name, passwordHash);
    if (robot != null) {
      _robot = robot;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> refreshRobot({bool suppressLogs = false}) async {
    if (_robot == null) return;

    try {
      final response = await Supabase.instance.client
          .from('robot_model')
          .select()
          .eq('id', _robot!.id)
          .maybeSingle();

      if (response != null) {
        _robot = RobotModel.fromJson(response as Map<String, dynamic>);
        notifyListeners();
      }
    } catch (e) {
      if (!suppressLogs) {
        debugPrint('Error refreshing robot: $e');
      }
    }
  }

  void logout() {
    _robot = null;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SaveEat',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          if (!auth.isAuthenticated) {
            return const LoginPage();
          }
          return const MainWrapper();
        },
      ),
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
    const QrScanPage(),
    const ReportsPage(),
    const SettingsPage(),
  ];

  final List<String> _appBarTitles = [
    'DASHBOARD',
    'ROBOT',
    'QR SCAN',
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
            icon: Image.asset('assets/icons/robot.png',
                width: 24, height: 24, color: const Color(0xFF505050)),
            activeIcon: Image.asset(
              'assets/icons/robot.png',
              width: 24,
              height: 24,
              color: Colors.black,
            ),
            label: 'Robot',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/qr_code.png',
                width: 24, height: 24, color: const Color(0xFF505050)),
            activeIcon: Image.asset(
              'assets/icons/qr_code.png',
              width: 24,
              height: 24,
              color: Colors.black,
            ),
            label: 'QR Scan',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/reports.png',
                width: 24, height: 24, color: const Color(0xFF505050)),
            activeIcon: Image.asset(
              'assets/icons/reports.png',
              width: 24,
              height: 24,
              color: Colors.black,
            ),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/settings.png',
                width: 24, height: 24, color: const Color(0xFF505050)),
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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Robot Login'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Robot Name'),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter robot name' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter password' : null,
                ),
                const SizedBox(height: 24),
                _loading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => _loading = true);
                            final ok = await Provider.of<AuthProvider>(context,
                                    listen: false)
                                .login(_nameController.text,
                                    _passwordController.text);
                            setState(() => _loading = false);
                            if (!ok) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Invalid credentials')),
                              );
                            }
                          }
                        },
                        child: const Text('Login'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
