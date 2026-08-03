import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(const FramerateApp());
}

class GlobalState {
  static final GlobalState _instance = GlobalState._internal();
  factory GlobalState() => _instance;
  GlobalState._internal();

  bool isLocked = false;
  String pin = "";
}

final globalState = GlobalState();

class FramerateApp extends StatelessWidget {
  const FramerateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Framerate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: ColorScheme.dark(
          primary: Colors.deepPurpleAccent,
          secondary: Colors.amberAccent,
        ),
      ),
      home: globalState.isLocked ? const PinLockScreen() : const MainHomeScreen(),
    );
  }
}

class PinLockScreen extends StatefulWidget {
  const PinLockScreen({super.key});

  @override
  State<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends State<PinLockScreen> {
  String enteredPin = "";

  void _onDigitPress(String digit) {
    setState(() {
      if (enteredPin.length < 4) {
        enteredPin += digit;
      }
      if (enteredPin.length == 4) {
        if (enteredPin == globalState.pin) {
          globalState.isLocked = false;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainHomeScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Incorrect PIN')),
          );
          enteredPin = "";
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Enter App PIN', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Container(
                  margin: const EdgeInsets.all(8),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index < enteredPin.length ? Colors.deepPurpleAccent : Colors.grey,
                  ),
                );
              }),
            ),
            const SizedBox(height: 30),
            for (var row in [['1', '2', '3'], ['4', '5', '6'], ['7', '8', '9'], ['', '0', '']])
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: row.map((digit) {
                  if (digit.isEmpty) return const SizedBox(width: 70, height: 70);
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      onPressed: () => _onDigitPress(digit),
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                      ),
                      child: Text(digit, style: const TextStyle(fontSize: 22)),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const MediaTrackerScreen(),
    const FranchiseScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Tracker'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Franchises'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

class MediaTrackerScreen extends StatelessWidget {
  const MediaTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Media & Franchise Tracker')),
      body: const Center(child: Text('Welcome to Framerate Tracker', style: TextStyle(fontSize: 18))),
    );
  }
}

class FranchiseScreen extends StatelessWidget {
  const FranchiseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Franchises')),
      body: const Center(child: Text('Organize your franchises here', style: TextStyle(fontSize: 18))),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pinEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pinEnabled = prefs.getBool('pin_enabled') ?? false;
      globalState.pin = prefs.getString('app_pin') ?? "1234";
      globalState.isLocked = _pinEnabled;
    });
  }

  Future<void> _togglePin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pinEnabled = value;
      prefs.setBool('pin_enabled', value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Enable App Lock PIN'),
            value: _pinEnabled,
            onChanged: _togglePin,
          ),
          ListTile(
            title: const Text('Change PIN'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () async {
              String newPin = "";
              await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Set New 4-Digit PIN'),
                  content: TextField(
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    obscureText: true,
                    onChanged: (val) => newPin = val,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        if (newPin.length == 4) {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString('app_pin', newPin);
                          globalState.pin = newPin;
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('PIN updated successfully')),
                          );
                        }
                      },
                      child: const Text('Save'),
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
