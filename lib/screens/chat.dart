//chat.dart
import 'package:firebase_project/widgets/chat_message.dart';
import 'package:firebase_project/widgets/new_message.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlutterChat'),
        actions: [
          IconButton(onPressed: (){
            FirebaseAuth.instance.signOut();
          }, icon: Icon(Icons.logout_rounded))
        ],
      ),
      body: Column(
        children: const [
          Expanded(child: ChatMessages(),
          ),
          NewMessage()
        ],
      )
      );

  }
}