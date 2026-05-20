import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_role.dart';
import '../services/app_state.dart';
import 'add_page.dart';
import 'chat_page.dart';
import 'favorites_page.dart';
import 'menu_page.dart';
import 'owner_properties_screen.dart';
import 'reservation_requests_screen.dart';
import 'tenant_bookings_screen.dart';
import 'tenant_home_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isOwner = context.watch<AppState>().role == UserRole.owner;
    final pendingCount = context.watch<AppState>().pendingReservationCount;
    final paymentCount = context.watch<AppState>().pendingPayments.length;

    if (isOwner) {
      const pages = [
        OwnerPropertiesScreen(),
        ReservationRequestsScreen(),
        ChatPage(),
        AddPage(),
        MenuPage(),
      ];

      return Scaffold(
        body: pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (i) => setState(() => _selectedIndex = i),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF007A3D),
          unselectedItemColor: Colors.grey,
          selectedFontSize: 10,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.apartment_outlined),
              activeIcon: Icon(Icons.apartment),
              label: 'Mes biens',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: pendingCount > 0,
                label: Text('$pendingCount'),
                child: const Icon(Icons.inbox_outlined),
              ),
              label: 'Demandes',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              label: 'Messages',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.add_circle, color: Colors.orange, size: 26),
              label: 'Ajouter',
            ),
            const BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
          ],
        ),
      );
    }

    const tenantPages = [
      TenantHomeScreen(),
      FavoritesPage(),
      TenantBookingsScreen(),
      ChatPage(),
      MenuPage(),
    ];

    return Scaffold(
      body: tenantPages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF007A3D),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 10,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Accueil',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Favoris',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: paymentCount > 0,
              label: Text('$paymentCount'),
              child: const Icon(Icons.payment_outlined),
            ),
            label: 'Paiement',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Messages',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
        ],
      ),
    );
  }
}
