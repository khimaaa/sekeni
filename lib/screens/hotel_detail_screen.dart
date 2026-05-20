import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/hotel.dart';
import '../models/user_role.dart';
import '../services/app_state.dart';
import '../widgets/property_image.dart';

class HotelDetailScreen extends StatelessWidget {
  const HotelDetailScreen({super.key, required this.hotel});

  final HotelItem hotel;

  HotelRoom _roomFromState(AppState app, HotelRoom room) {
    final h = app.hotels.where((x) => x.id == hotel.id).firstOrNull;
    if (h == null) return room;
    return h.rooms.where((r) => r.id == room.id).firstOrNull ?? room;
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final isTenant = app.role == UserRole.tenant;
    final rooms = hotel.rooms.map((r) => _roomFromState(app, r)).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: const Color(0xFF007A3D),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                hotel.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: PropertyImage(
                imagePath: hotel.coverImage,
                height: 240,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotel.locationLabel,
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Photos de l\'hôtel',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 100,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: hotel.galleryImages.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (_, i) => ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: PropertyImage(
                          imagePath: hotel.galleryImages[i],
                          height: 100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Restaurant',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.restaurant, color: Colors.orange),
                        const SizedBox(width: 12),
                        Expanded(child: Text(hotel.restaurantInfo)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Réserver une chambre',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...rooms.map((room) => _roomCard(context, room, isTenant)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _roomCard(BuildContext context, HotelRoom room, bool isTenant) {
    final avail = room.isAvailable;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (room.images.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: PropertyImage(imagePath: room.images.first, height: 160),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  room.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(room.description, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                Text(
                  room.price,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Color(0xFF007A3D),
                  ),
                ),
                if (!avail)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      'Chambre indisponible',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (isTenant) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _contact(context, hotel.ownerPhone),
                          child: const Text('Contacter'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: avail
                              ? () {
                            context
                                .read<AppState>()
                                .submitHotelReservation(hotel, room);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Demande de chambre envoyée !'),
                                backgroundColor: Color(0xFF007A3D),
                              ),
                            );
                          }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                avail ? Colors.orange : Colors.grey,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Réserver'),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _contact(BuildContext context, String phone) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(phone, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: phone));
                Navigator.pop(ctx);
              },
              icon: const Icon(Icons.copy),
              label: const Text('Copier'),
            ),
          ],
        ),
      ),
    );
  }
}
