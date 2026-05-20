import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/property.dart';
import '../services/app_state.dart';
import '../services/locale_service.dart';
import '../utils/l10n_helper.dart';
import '../widgets/property_card.dart';
import 'hotel_detail_screen.dart';

class TenantHomeScreen extends StatefulWidget {
  const TenantHomeScreen({super.key});

  @override
  State<TenantHomeScreen> createState() => _TenantHomeScreenState();
}

class _TenantHomeScreenState extends State<TenantHomeScreen> {
  int selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final l = context.watch<LocaleService>();
    final name = appState.userName;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.t('Trouvez votre', 'اعثر على'),
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      l.t('meilleur logement', 'أفضل مكان للإقامة'),
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                CircleAvatar(
                  radius: 24,
                  backgroundColor: const Color(0xFFE5E5E5),
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : 'U',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: l.t('Rechercher un quartier...', 'ابحث عن حي...'),
                  border: InputBorder.none,
                  icon: const Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              l.t('Catégories', 'الفئات'),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _cat(l.t('Maison', 'منزل'), Icons.home, Colors.orange, 0),
                  _cat(l.t('Hôtel', 'فندق'), Icons.hotel, Colors.red, 1),
                  _cat(l.t('Appartement', 'شقة'), Icons.apartment, Colors.blueGrey, 2),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Text(
              _sectionTitle(l),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            if (selectedCategory == 1)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  l.t('Nouakchott & Nouadhibou', 'نواكشوط ونواذيبو'),
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            if (selectedCategory == 2)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  l.t(
                    'Appartements meublés — 24h, 48h ou 1 mois',
                    'شقق مفروشة — 24 ساعة، 48 ساعة أو شهر',
                  ),
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            const SizedBox(height: 20),
            if (selectedCategory == 1) _hotelList(appState, l) else _propertyList(appState),
          ],
        ),
      ),
    );
  }

  String _sectionTitle(LocaleService l) {
    switch (selectedCategory) {
      case 0:
        return l.t('Location au mois — Nouakchott', 'إيجار شهري — نواكشوط');
      case 1:
        return l.t('Hôtels', 'الفنادق');
      default:
        return l.t('Appartements meublés', 'شقق مفروشة');
    }
  }

  Widget _propertyList(AppState appState) {
    final cat = selectedCategory == 0
        ? PropertyCategory.home
        : PropertyCategory.apartment;
    final list = appState.propertiesByCategory(cat);
    return Column(
      children: list
          .map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: PropertyCard(property: p),
              ))
          .toList(),
    );
  }

  Widget _hotelList(AppState appState, LocaleService l) {
    return Column(
      children: appState.hotels.map((hotel) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HotelDetailScreen(hotel: hotel),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        hotel.coverImage,
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 72,
                          height: 72,
                          color: Colors.red.withValues(alpha: 0.1),
                          child: const Icon(Icons.hotel, color: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hotel.localizedName(l),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          Text(
                            hotel.locationLabel,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          Text(
                            l.t(
                              '${hotel.rooms.length} types de chambres',
                              '${hotel.rooms.length} أنواع غرف',
                            ),
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 18),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _cat(String title, IconData icon, Color color, int index) {
    final sel = selectedCategory == index;
    return GestureDetector(
      onTap: () => setState(() => selectedCategory = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        decoration: BoxDecoration(
          color: sel ? color : Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: sel ? Colors.white : color),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: sel ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
