import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/app_state.dart';
import '../widgets/property_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<AppState>().favoriteProperties;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Favoris'),
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite_border, size: 72, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text(
                    'Aucun favori',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Appuyez sur ❤️ sur une maison, hôtel ou appartement',
                    style: TextStyle(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: favorites.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: PropertyCard(property: favorites[i]),
              ),
            ),
    );
  }
}
