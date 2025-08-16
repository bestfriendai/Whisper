import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lockerroomtalk/providers/app_state_provider.dart';
import 'package:lockerroomtalk/screens/home/simple_home_feed.dart';
import 'package:lockerroomtalk/screens/chat/simple_chat_rooms_screen.dart';
import 'package:lockerroomtalk/screens/create/simple_create_screen.dart';
import 'package:lockerroomtalk/screens/auth/modern_auth_screen.dart';

class SimpleAppShell extends StatefulWidget {
  const SimpleAppShell({Key? key}) : super(key: key);

  @override
  State<SimpleAppShell> createState() => _SimpleAppShellState();
}

class _SimpleAppShellState extends State<SimpleAppShell> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const SimpleHomeFeed(),
    const SimpleChatRoomsScreen(),
    const SimpleCreateScreen(),
    const SimpleAlertsScreen(),
    const SimpleSettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home, 'Browse', const Color(0xFFE74C3C)),
              _buildNavItem(1, Icons.search, 'Search', Colors.grey),
              _buildNavItem(2, Icons.add_circle, '', const Color(0xFFCD6B47)),
              _buildNavItem(3, Icons.notifications, 'Alerts', Colors.grey),
              _buildNavItem(4, Icons.settings, 'Settings', Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, Color color) {
    final isSelected = _currentIndex == index;
    final isCreateButton = index == 2;
    final appState = context.watch<AppStateProvider>();
    final isRestricted = appState.isGuest && (index == 2);

    if (isCreateButton) {
      return GestureDetector(
        onTap: () => _onTabSelected(index),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: isRestricted ? Colors.grey.shade400 : color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: (isRestricted ? Colors.grey : color).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            isRestricted ? Icons.lock : icon,
            color: Colors.white,
            size: 28,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => _onTabSelected(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Icon(
                icon,
                color: isSelected ? color : Colors.grey.shade400,
                size: 28,
              ),
              if (index == 3 && !appState.isGuest) // Alerts badge
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: const Text(
                      '3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          if (label.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? color : Colors.grey.shade400,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _onTabSelected(int index) {
    final appState = context.read<AppStateProvider>();
    
    // Check if guest and trying to access restricted features
    if (appState.isGuest && index == 2) {
      _showGuestRestrictionDialog();
      return;
    }

    setState(() {
      _currentIndex = index;
    });
  }

  void _showGuestRestrictionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(Icons.lock_outline, color: Color(0xFFCD6B47)),
            SizedBox(width: 12),
            Text('Sign Up Required'),
          ],
        ),
        content: const Text(
          'Create a free account to:\n• Post reviews\n• Join chat rooms\n• Access all features',
          style: TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Maybe Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const ModernAuthScreen(),
                ),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFCD6B47),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Sign Up'),
          ),
        ],
      ),
    );
  }
}

// Simple Search Screen
class SimpleSearchScreen extends StatelessWidget {
  const SimpleSearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCD6B47),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  const Text(
                    'Search Reviews',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            
            // Search content
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    // Search bar
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'Search by name, location, or keywords...',
                          border: InputBorder.none,
                          icon: Icon(Icons.search, color: Colors.grey),
                        ),
                      ),
                    ),
                    
                    // Search results placeholder
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Start typing to search reviews',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Simple Alerts Screen
class SimpleAlertsScreen extends StatelessWidget {
  const SimpleAlertsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCD6B47),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              child: const Row(
                children: [
                  Icon(Icons.notifications, color: Colors.white, size: 24),
                  SizedBox(width: 12),
                  Text(
                    'Alerts',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            
            // Alerts content
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildAlertItem(
                      'New review posted',
                      'Someone posted a review near you',
                      '2m ago',
                      Colors.blue,
                    ),
                    _buildAlertItem(
                      'Review reported',
                      'A review you reported has been removed',
                      '1h ago',
                      Colors.red,
                    ),
                    _buildAlertItem(
                      'New chat message',
                      'You have a new message in General chat',
                      '3h ago',
                      Colors.green,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertItem(String title, String description, String time, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

// Simple Settings Screen
class SimpleSettingsScreen extends StatelessWidget {
  const SimpleSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCD6B47),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              child: const Row(
                children: [
                  Icon(Icons.settings, color: Colors.white, size: 24),
                  SizedBox(width: 12),
                  Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            
            // Settings content
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildSettingsSection('Account', [
                      _buildSettingsItem(Icons.person, 'Profile', () {}),
                      _buildSettingsItem(Icons.security, 'Privacy & Security', () {}),
                      _buildSettingsItem(Icons.notifications, 'Notifications', () {}),
                    ]),
                    _buildSettingsSection('App', [
                      _buildSettingsItem(Icons.dark_mode, 'Dark Mode', () {}),
                      _buildSettingsItem(Icons.language, 'Language', () {}),
                      _buildSettingsItem(Icons.info, 'About', () {}),
                    ]),
                    _buildSettingsSection('Support', [
                      _buildSettingsItem(Icons.help, 'Help & Support', () {}),
                      _buildSettingsItem(Icons.feedback, 'Send Feedback', () {}),
                      _buildSettingsItem(Icons.logout, 'Sign Out', () {}, isDestructive: true),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: items),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : const Color(0xFFCD6B47),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : Colors.black,
          fontSize: 16,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}