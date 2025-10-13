import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:museum_app/presentation/screens/home/home_screen.dart';
import 'package:museum_app/presentation/screens/tickets/tickets_screen.dart';
import 'package:museum_app/presentation/screens/saved/saved_screen.dart';
import 'package:museum_app/presentation/screens/profile/profile_screen.dart';
import 'package:museum_app/presentation/widgets/scan_button.dart';
import 'package:museum_app/presentation/navigation/routes.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomeScreen(),
      const TicketsScreen(),
      const SavedScreen(key: PageStorageKey('saved_screen')),
      const ProfileScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      floatingActionButton: ScanButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        selectedItemColor: const Color(0xFFA69365),
        elevation: 0,
        backgroundColor: Colors.white,
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: l10n.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.confirmation_number_outlined),
            activeIcon: const Icon(Icons.confirmation_number),
            label: l10n.tickets,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.bookmark_outline),
            activeIcon: const Icon(Icons.bookmark),
            label: l10n.savedArtworks,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: l10n.profile,
          ),
        ],
      ),
    );
  }
}
