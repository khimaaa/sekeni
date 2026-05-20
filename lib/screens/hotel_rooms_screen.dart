import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/hotel.dart';
import '../services/app_state.dart';

class HotelRoomsScreen extends StatelessWidget {
  const HotelRoomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final available = context.watch<AppState>().availableHotelRooms;
    final unavailable = context.watch<AppState>().unavailableHotelRooms;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Chambres',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
              TabBar(
                labelColor: Colors.red,
                tabs: [
                  Tab(text: 'Disponibles (${available.length})'),
                  Tab(text: 'Indisponibles (${unavailable.length})'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _list(context, available, true),
                    _list(context, unavailable, false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _list(BuildContext context, List<HotelRoom> rooms, bool avail) {
    if (rooms.isEmpty) {
      return const Center(child: Text('Aucune chambre'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: rooms.length,
      itemBuilder: (_, i) {
        final r = rooms[i];
        return Card(
          child: ListTile(
            title: Text(r.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${r.price}\n${r.description}'),
            isThreeLine: true,
            trailing: Switch(
              value: r.isAvailable,
              activeThumbColor: Colors.green,
              onChanged: (_) =>
                  context.read<AppState>().toggleHotelRoomAvailability(r.id),
            ),
          ),
        );
      },
    );
  }
}
