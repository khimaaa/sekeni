import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/property.dart';
import '../screens/property_detail_screen.dart';
import '../services/app_state.dart';
import '../services/locale_service.dart';
import '../utils/l10n_helper.dart';
import 'local_image.dart';

class PropertyCard extends StatelessWidget {
  const PropertyCard({super.key, required this.property});

  final PropertyItem property;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final l = context.watch<LocaleService>();
    final isFav = appState.isFavorite(property.id);
    final avail = property.isAvailable;

    return Opacity(
      opacity: avail ? 1 : 0.85,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          children: [
            Stack(
              children: [
                LocalImage(
                  path: property.image,
                  height: 220,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                if (!avail)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'INDISPONIBLE',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Material(
                    color: Colors.white.withValues(alpha: 0.95),
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: () => appState.toggleFavorite(property.id),
                      customBorder: const CircleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                if (property.isFurnished)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF007A3D),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        l.t('Meublé', 'مفروش'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                          Text(
                            property.localizedTitle(l),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(property.locationFull, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 6),
                  Text(
                    property.price,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                    _chip(
                      Icons.door_front_door,
                      l.t('${property.totalRooms} pièces', '${property.totalRooms} غرف'),
                    ),
                    _chip(
                      Icons.kitchen,
                      property.hasKitchen
                          ? l.t('Cuisine', 'مطبخ')
                          : l.t('Sans cuisine', 'بدون مطبخ'),
                    ),
                    _chip(
                      Icons.garage,
                      property.hasGarage
                          ? l.t('Garage', 'مرآب')
                          : l.t('Sans garage', 'بدون مرآب'),
                    ),
                    if (property.isFurnished && property.hasWifi)
                      _chip(Icons.wifi, l.t('Wifi', 'واي فاي')),
                    ],
                  ),
                  if (property.rentOptions.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      property.rentOptions.join(' • '),
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                  ],
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                PropertyDetailScreen(property: property),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            avail ? const Color(0xFF2C3E50) : Colors.grey,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        avail
                            ? l.t('Voir le détail', 'عرض التفاصيل')
                            : l.t('Voir (indisponible)', 'عرض (غير متاح)'),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
