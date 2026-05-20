import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_role.dart';
import '../services/app_state.dart';
import 'favorites_page.dart';
import 'role_selection_screen.dart';
import 'owner_properties_screen.dart';
import 'reservation_requests_screen.dart';
import 'tenant_bookings_screen.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isOwner = appState.role == UserRole.owner;
    final isHotel = appState.role == UserRole.hotel;
    final roleLabel = appState.role?.title ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Menu',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              if (roleLabel.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Sekeni • $roleLabel • ${appState.userName ?? ''}',
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF007A3D), Color(0xFF005C2E)],
                  ),
                ),
                child: const Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.workspace_premium,
                        color: Color(0xFFFFD700),
                        size: 30,
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sekeni Premium',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Avantages exclusifs',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Général',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              if (isHotel) ...[
                _item(
                  context,
                  Icons.bed,
                  Colors.red,
                  'Chambres',
                  () => _snack(context, 'Utilisez l\'onglet Chambres en bas'),
                ),
                _item(
                  context,
                  Icons.groups,
                  Colors.blue,
                  'Salles de conférence',
                  () => _snack(context, 'Utilisez l\'onglet Conférences'),
                ),
              ] else if (isOwner) ...[
                _item(
                  context,
                  Icons.apartment,
                  Colors.orange,
                  'Mes biens',
                  () => _push(context, const OwnerPropertiesScreen()),
                ),
                _item(
                  context,
                  Icons.inbox,
                  Colors.blue,
                  'Demandes de réservation',
                  () => _push(context, const ReservationRequestsScreen()),
                ),
              ] else ...[
                _item(
                  context,
                  Icons.favorite,
                  Colors.red,
                  'Mes favoris',
                  () => _push(context, const FavoritesPage()),
                ),
                _item(
                  context,
                  Icons.payment,
                  Colors.green,
                  'Réservations & paiements',
                  () => _push(context, const TenantBookingsScreen()),
                ),
              ],
              _item(
                context,
                Icons.notifications,
                Colors.deepPurple,
                'Notifications',
                () => _snack(context, 'Notifications — bientôt disponible'),
              ),
              _item(
                context,
                Icons.help_outline,
                Colors.teal,
                'Aide & support',
                () => _snack(context, 'Support Sekeni: support@sekeni.mr'),
              ),
              const SizedBox(height: 25),
              GestureDetector(
                onTap: () {
                  context.read<AppState>().logout();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RoleSelectionScreen(),
                    ),
                    (_) => false,
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1F1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, color: Colors.red),
                      SizedBox(width: 10),
                      Text(
                        'Déconnexion',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _push(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Widget _item(
    BuildContext context,
    IconData icon,
    Color color,
    String title,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
