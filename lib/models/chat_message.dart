class ChatMessage {
  final String role; // 'system', 'user', or 'assistant'
  final String content;

  ChatMessage({required this.role, required this.content});

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'content': content,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      role: json['role'] as String,
      content: json['content'] as String,
    );
  }

  @override
  String toString() {
    return 'ChatMessage{role: $role, content: $content}';
  }
}
