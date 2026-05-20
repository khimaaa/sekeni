import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/property.dart';
import '../models/reservation_request.dart';
import '../services/app_state.dart';

class ReservationRequestsScreen extends StatelessWidget {
  const ReservationRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pending = context.watch<AppState>().pendingReservations;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Text(
                'Demandes de réservation',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                pending.isEmpty
                    ? 'Aucune demande en attente'
                    : '${pending.length} demande(s) — accepter pour allouer l\'allongement',
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: pending.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Les locataires enverront leurs demandes ici',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: pending.length,
                      itemBuilder: (context, index) {
                        return _RequestCard(request: pending[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({required this.request});

  final ReservationRequest request;

  Future<void> _accept(BuildContext context) async {
    final appState = context.read<AppState>();
    final available = appState.availableOwnerProperties;

    if (available.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ajoutez un bien disponible avant d\'accepter'),
        ),
      );
      return;
    }

    final propertyId = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _PropertyPickerSheet(
        properties: available,
        request: request,
        suggestedId: appState.suggestOwnerPropertyId(request),
      ),
    );

    if (propertyId == null || !context.mounted) return;

    final accepted = appState.acceptReservation(request.id, propertyId);
    if (!context.mounted) return;

    if (!accepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible d\'accepter cette demande')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Allongement accepté — ${request.tenantName} apparaît dans « Indisponibles »',
        ),
        backgroundColor: const Color(0xFF007A3D),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.home, color: Colors.orange),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.propertyTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    Text(
                      request.location,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Text(
                request.price,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            children: [
              const Icon(Icons.person, size: 18, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Allongement: ${request.tenantName}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.phone, size: 18, color: Colors.grey),
              const SizedBox(width: 8),
              Text(request.tenantPhone),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Demandé le ${request.requestedAt}',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    appState.rejectReservation(request.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Demande refusée')),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Refuser'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _accept(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007A3D),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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

class _PropertyPickerSheet extends StatelessWidget {
  const _PropertyPickerSheet({
    required this.properties,
    required this.request,
    this.suggestedId,
  });

  final List<PropertyItem> properties;
  final ReservationRequest request;
  final String? suggestedId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quel bien attribuer ?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Allongement: ${request.tenantName}',
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ...properties.map((p) {
            final isSuggested = p.id == suggestedId;
            return ListTile(
              leading: Icon(
                p.category == PropertyCategory.apartment
                    ? Icons.apartment
                    : p.category == PropertyCategory.hotel
                        ? Icons.hotel
                        : Icons.home,
                color: const Color(0xFF007A3D),
              ),
              title: Text(p.title),
              subtitle: Text('${p.location} • ${p.price}'),
              trailing: isSuggested
                  ? const Chip(
                      label: Text('Suggéré'),
                      backgroundColor: Color(0xFFE8F5E9),
                    )
                  : null,
              onTap: () => Navigator.pop(context, p.id),
            );
          }),
        ],
      ),
    );
  }
}
