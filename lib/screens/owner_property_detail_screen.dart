import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/payment_record.dart';
import '../models/property.dart';
import '../services/app_state.dart';
import '../widgets/local_image.dart';

class OwnerPropertyDetailScreen extends StatelessWidget {
  const OwnerPropertyDetailScreen({super.key, required this.property});

  final PropertyItem property;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Détail du bien'),
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LocalImage(path: property.image, height: 200),
          ),
          const SizedBox(height: 16),
          Text(
            property.title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(property.locationFull, style: const TextStyle(color: Colors.grey)),
          Text(
            property.price,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: property.isAvailable
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              property.isAvailable
                  ? 'Disponible à la location'
                  : 'Indisponible — Allongement: ${property.currentTenantName ?? "—"}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          if (!property.isAvailable) ...[
            const SizedBox(height: 20),
            const Text(
              'Paiements avec l\'allongement',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...property.monthlyPayments.map(_paymentCard),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  context.read<AppState>().endRentalByOwner(property.id);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Bien rendu disponible — fin de l\'allongement',
                      ),
                      backgroundColor: Color(0xFF007A3D),
                    ),
                  );
                },
                icon: const Icon(Icons.lock_open),
                label: const Text('Terminer la location / Rendre disponible'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _paymentCard(PaymentRecord payment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(payment.monthLabel,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('${payment.tenantName} — ${payment.amountMru}'),
              ],
            ),
          ),
          Text(
            payment.isPaid ? 'Payé' : 'En attente',
            style: TextStyle(
              color: payment.isPaid ? Colors.green : Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
