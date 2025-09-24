import 'package:chat_app/models/message_model.dart';
import 'package:flutter/material.dart';

class PubleChat extends StatelessWidget {
  const PubleChat({super.key, required this.message, required this.email});
  final MessageModel message;
  final String email;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, top: 10, bottom: 10, right: 5),
      child: Align(
        alignment: message.id == email
            ? Alignment.centerLeft
            : Alignment.centerRight,
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: message.id == email
                ? BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )
                : BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
            color: message.id == email ? Colors.white : Colors.grey[400],
          ),
          child: Text(
            message.message,
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
