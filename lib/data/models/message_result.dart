import 'dart:ui';


class MessageResult {
  final Color color;
  final String message;

  MessageResult({
    required this.message,
    required this.color
  });

  factory MessageResult.success({required String message}){
    return MessageResult(
        color: const Color(0xFF2E7D32),
        message: message
    );
  }

  factory MessageResult.error({required String message}){
    return MessageResult(
        color: const Color(0xFFC62828),
        message: message
    );
  }
}