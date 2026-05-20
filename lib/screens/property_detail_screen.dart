import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/property.dart';
import '../models/room_detail.dart';
import '../models/user_role.dart';
import '../services/app_state.dart';
import '../services/locale_service.dart';
import '../utils/l10n_helper.dart';
import '../widgets/property_image.dart';

class PropertyDetailScreen extends StatelessWidget {
  const PropertyDetailScreen({
    super.key,
    required this.property,
    this.showTenantActions = true,
  });

  final PropertyItem property;
  final bool showTenantActions;

  @override
  Widget build(BuildContext context) {
    final l = context.watch<LocaleService>();
    final isTenant =
        showTenantActions && context.watch<AppState>().role == UserRole.tenant;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: const Color(0xFF007A3D),
            actions: [
              if (isTenant)
                IconButton(
                  onPressed: () =>
                      context.read<AppState>().toggleFavorite(property.id),
                  icon: Icon(
                    context.watch<AppState>().isFavorite(property.id)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Colors.white,
                  ),
                ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: PropertyImage(
                imagePath: property.image,
                height: 260,
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
                    property.localizedTitle(l),
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          property.locationFull,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (!property.isAvailable) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.block, color: Colors.red),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Ce bien est indisponible — déjà loué',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Text(
                    property.price,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF007A3D),
                    ),
                  ),
                  if (property.category == PropertyCategory.apartment)
                    const Text(
                      'Appartement meublé — durées flexibles',
                      style: TextStyle(color: Colors.grey),
                    )
                  else
                    const Text('Location au mois', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 20),
                  _infoGrid(),
                  const SizedBox(height: 24),
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    property.description,
                    style: TextStyle(color: Colors.grey[700], height: 1.5),
                  ),
                  if (property.rentOptions.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Text(
                      'Durées de location',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...property.rentOptions.map(
                      (o) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.schedule,
                              color: Colors.orange,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(o, style: const TextStyle(fontSize: 15)),
                          ],
                        ),
                      ),
                    ),
                  ],
                  if (property.roomDetails.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'Détail des pièces',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...property.roomDetails.map(_roomTile),
                    const SizedBox(height: 8),
                    Text(
                      'Toilettes: ${property.toilets}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                  if (isTenant) ...[
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () =>
                                _contact(context, property.ownerPhone),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: const BorderSide(
                                color: Color(0xFF007A3D),
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'Contacter',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF007A3D),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: property.isAvailable
                                ? () {
                              context
                                  .read<AppState>()
                                  .submitReservation(property);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Demande envoyée ! Vous serez notifié si acceptée.',
                                  ),
                                  backgroundColor: Color(0xFF007A3D),
                                ),
                              );
                              Navigator.pop(context);
                            }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: property.isAvailable
                                  ? Colors.orange
                                  : Colors.grey,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'Réserver',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoGrid() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _box('Pièces', '${property.totalRooms}'),
        _box('Toilettes', '${property.toilets}'),
        _box('Cuisine', property.hasKitchen ? 'Oui' : 'Non'),
        _box('Garage', property.hasGarage ? 'Oui' : 'Non'),
        if (property.isFurnished && property.hasWifi) _box('Wifi', 'Oui'),
      ],
    );
  }

  Widget _box(String label, String value) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8),
        ],
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _roomTile(RoomDetail room) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.meeting_room, color: Color(0xFF007A3D)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  room.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  room.description,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.phone_in_talk, size: 48, color: Color(0xFF007A3D)),
            const SizedBox(height: 16),
            const Text(
              'Numéro du propriétaire',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              phone,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: phone));
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Numéro copié')),
                  );
                },
                icon: const Icon(Icons.copy),
                label: const Text('Copier le numéro'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007A3D),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
