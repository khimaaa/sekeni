class ChatConversation {
  const ChatConversation({
    required this.id,
    required this.contactName,
    required this.contactRole,
    required this.lastMessage,
    required this.timeLabel,
    required this.messages,
    this.unread = 0,
  });

  final String id;
  final String contactName;
  final String contactRole;
  final String lastMessage;
  final String timeLabel;
  final List<ChatMessage> messages;
  final int unread;
}

class ChatMessage {
  const ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
  });

  final String text;
  final bool isMe;
  final String time;
}
