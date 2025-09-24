import 'package:chat_app/consts.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/widgets/puble_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  static String id = 'chatScreen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController controller = TextEditingController();
  ScrollController controllerListView = ScrollController();
  CollectionReference messages = FirebaseFirestore.instance.collection(
    kMessageCollection,
  );
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    String email = ModalRoute.of(context)!.settings.arguments as String;

    return StreamBuilder(
      stream: messages.orderBy('createdAt').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<MessageModel> messageList = [];
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (controllerListView.hasClients) {
              controllerListView.animateTo(
                controllerListView.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messageList.add(MessageModel.fromjson(snapshot.data!.docs[i]));
          }

          return Scaffold(
            backgroundColor: kMainColor,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              title: Row(children: [Image.asset(kLogoApp, height: 50)]),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: controllerListView,
                    itemCount: messageList.length,
                    itemBuilder: (context, index) {
                      return PubleChat(
                        message: messageList[index],
                        email: email,
                      );
                    },
                  ),
                ),
                TextField(
                  controller: controller,
                  onSubmitted: (data) {
                    messages.add({
                      'message': data,
                      'createdAt': FieldValue.serverTimestamp(),
                      'id': email,
                    });

                    controller.clear();
                  },
                  cursorColor: kMainColor,
                  decoration: InputDecoration(
                    filled: true,
                    // ignore: deprecated_member_use
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.face, color: kMainColor, size: 30),
                    suffixIcon: Icon(Icons.send, color: kMainColor),
                    hintText: 'Enter Message ...',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 0, color: kMainColor),
                      // borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 0, color: kMainColor),
                      // borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 0, color: kMainColor),
                      // borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Sorry there is an err')));
        } else {
          return Scaffold(
            backgroundColor: kMainColor,
            body: Center(child: CircularProgressIndicator(color: Colors.white)),
          );
        }
      },
    );
  }
}
