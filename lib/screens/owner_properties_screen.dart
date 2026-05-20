import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/property.dart';
import '../services/app_state.dart';
import 'owner_property_detail_screen.dart';

class OwnerPropertiesScreen extends StatelessWidget {
  const OwnerPropertiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Text(
                  'Mes biens',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Text(
                  'Disponibles et indisponibles',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
              const SizedBox(height: 16),
              TabBar(
                labelColor: const Color(0xFF2C3E50),
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.orange,
                tabs: [
                  Tab(
                    text:
                        'Disponibles (${context.watch<AppState>().availableOwnerProperties.length})',
                  ),
                  Tab(
                    text:
                        'Indisponibles (${context.watch<AppState>().unavailableOwnerProperties.length})',
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _PropertyList(
                      properties:
                          context.watch<AppState>().availableOwnerProperties,
                      emptyMessage: 'Aucun bien disponible',
                    ),
                    _PropertyList(
                      properties:
                          context.watch<AppState>().unavailableOwnerProperties,
                      emptyMessage: 'Aucun bien loué pour le moment',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PropertyList extends StatelessWidget {
  const _PropertyList({
    required this.properties,
    required this.emptyMessage,
  });

  final List<PropertyItem> properties;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (properties.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: properties.length,
      itemBuilder: (context, index) {
        final property = properties[index];
        return _OwnerPropertyTile(property: property);
      },
    );
  }
}

class _OwnerPropertyTile extends StatelessWidget {
  const _OwnerPropertyTile({required this.property});

  final PropertyItem property;

  @override
  Widget build(BuildContext context) {
    final statusColor = property.isAvailable ? Colors.green : Colors.red;
    final statusText =
        property.isAvailable ? 'Disponible' : 'Indisponible (loué)';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OwnerPropertyDetailScreen(property: property),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    property.category == PropertyCategory.hotel
                        ? Icons.hotel
                        : property.category == PropertyCategory.apartment
                            ? Icons.apartment
                            : Icons.home,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        property.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        property.location,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        property.price,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      if (!property.isAvailable &&
                          property.currentTenantName != null) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.person,
                              size: 14,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'Allongement: ${property.currentTenantName}',
                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Voir détail',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
