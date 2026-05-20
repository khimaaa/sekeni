import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/reservation_request.dart';
import '../services/app_state.dart';

class HotelReservationsScreen extends StatelessWidget {
  const HotelReservationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hotelName = context.watch<AppState>().hotelName ?? 'Hôtel';
    final pending = context.watch<AppState>().hotelPendingReservations;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotelName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Gestion des réservations',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            Expanded(
              child: pending.isEmpty
                  ? const Center(child: Text('Aucune demande en attente'))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: pending.length,
                      itemBuilder: (_, i) => _Card(request: pending[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.request});
  final ReservationRequest request;

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            request.propertyTitle,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          Text('${request.tenantName} • ${request.tenantPhone}'),
          Text(request.price, style: const TextStyle(color: Color(0xFF007A3D))),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => app.rejectReservation(request.id),
                  child: const Text('Refuser'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    app.acceptHotelReservation(request.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Réservation acceptée — chambre indisponible'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Accepter'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
