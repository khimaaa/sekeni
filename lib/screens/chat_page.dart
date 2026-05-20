import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/app_state.dart';
import 'chat_detail_screen.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final conversations = context.watch<AppState>().conversations;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Messages',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: conversations.length,
        separatorBuilder: (_, __) => const Divider(height: 1, indent: 80),
        itemBuilder: (_, i) {
          final c = conversations[i];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF007A3D).withValues(alpha: 0.15),
              child: Text(
                c.contactName.isNotEmpty ? c.contactName[0] : '?',
                style: const TextStyle(
                  color: Color(0xFF007A3D),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    c.contactName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Text(c.timeLabel, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            subtitle: Text(
              c.lastMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: c.unread > 0
                ? CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.orange,
                    child: Text(
                      '${c.unread}',
                      style: const TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  )
                : null,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatDetailScreen(conversationId: c.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
