import 'package:flutter/material.dart';

class MessageLog extends StatelessWidget {
  final List<String> messages;
  const MessageLog({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height * 0.1,
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      decoration: BoxDecoration(
        color: Color(0xFF161B22),
        border: BoxBorder.all(color: Color(0xFF262C36)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final m in messages.take(3))
            Text(
              m,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: Color(0xFF9BA7B4),
              ),
            ),
        ],
      ),
    );
  }
}
