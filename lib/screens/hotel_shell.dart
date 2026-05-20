import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/app_state.dart';
import 'chat_page.dart';
import 'hotel_conference_screen.dart';
import 'hotel_reservations_screen.dart';
import 'hotel_rooms_screen.dart';
import 'menu_page.dart';

class HotelShell extends StatefulWidget {
  const HotelShell({super.key});

  @override
  State<HotelShell> createState() => _HotelShellState();
}

class _HotelShellState extends State<HotelShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pending = context.watch<AppState>().hotelPendingReservations.length;

    const pages = [
      HotelReservationsScreen(),
      HotelRoomsScreen(),
      HotelConferenceScreen(),
      ChatPage(),
      MenuPage(),
    ];

    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 10,
        items: [
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: pending > 0,
              label: Text('$pending'),
              child: const Icon(Icons.inbox_outlined),
            ),
            label: 'Réservations',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.bed_outlined),
            activeIcon: Icon(Icons.bed),
            label: 'Chambres',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.groups_outlined),
            label: 'Conférences',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Messages',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menu',
          ),
        ],
      ),
    );
  }
}
