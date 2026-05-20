import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/app_state.dart';

class HotelConferenceScreen extends StatelessWidget {
  const HotelConferenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rooms = context.watch<AppState>().hotelConferenceRooms;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Salles de conférence',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Disponibilité et réservations',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: rooms.length,
                itemBuilder: (_, i) {
                  final r = rooms[i];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  r.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: (r.isAvailable ? Colors.green : Colors.red)
                                      .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  r.isAvailable ? 'Disponible' : 'Occupée',
                                  style: TextStyle(
                                    color:
                                        r.isAvailable ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('Capacité: ${r.capacity} personnes'),
                          Text(r.pricePerDay,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF007A3D),
                              )),
                          Text(r.description,
                              style: const TextStyle(color: Colors.grey)),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => context
                                  .read<AppState>()
                                  .toggleConferenceAvailability(r.id),
                              child: Text(
                                r.isAvailable
                                    ? 'Marquer occupée'
                                    : 'Rendre disponible',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
