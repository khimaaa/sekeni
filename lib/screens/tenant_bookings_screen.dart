import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/tenant_booking.dart';
import '../services/app_state.dart';

class TenantBookingsScreen extends StatelessWidget {
  const TenantBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookings = context.watch<AppState>().myBookings;
    final pending = context.watch<AppState>().pendingPayments;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Mes réservations'),
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: bookings.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Aucune réservation acceptée pour le moment',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                if (pending.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF007A3D)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.check_circle, color: Color(0xFF007A3D)),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Votre réservation a été acceptée ! Procédez au paiement ci-dessous.',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ...bookings.map((b) => _BookingCard(booking: b)),
              ],
            ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({required this.booking});

  final TenantBooking booking;

  @override
  Widget build(BuildContext context) {
    final paid = booking.paymentStatus == PaymentStatus.paid;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF007A3D).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Acceptée',
                  style: TextStyle(
                    color: Color(0xFF007A3D),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: (paid ? Colors.green : Colors.orange)
                      .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  paid ? 'Payé' : 'Paiement en attente',
                  style: TextStyle(
                    color: paid ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            booking.propertyTitle,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(booking.location, style: const TextStyle(color: Colors.grey)),
          Text('Accepté le ${booking.acceptedAt}'),
          const SizedBox(height: 12),
          Text(
            booking.amountMru,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF007A3D),
            ),
          ),
          if (!paid) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.read<AppState>().payBooking(booking.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Paiement enregistré — merci !'),
                      backgroundColor: Color(0xFF007A3D),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007A3D),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Payer maintenant',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Fin de location'),
                    content: const Text(
                      'Voulez-vous quitter ce logement ? Le bien redeviendra disponible pour d\'autres.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Annuler'),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<AppState>().endRentalByTenant(booking.id);
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Location terminée'),
                            ),
                          );
                        },
                        child: const Text('Confirmer'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.exit_to_app, color: Colors.red),
              label: const Text(
                'Terminer ma location',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
