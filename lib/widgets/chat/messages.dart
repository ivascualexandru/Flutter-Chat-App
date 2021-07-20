import 'package:chat_app/widgets/chat/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  const Messages();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.value(FirebaseAuth.instance.currentUser),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('chat')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (ctx, chatSnapshot) {
              if (chatSnapshot.connectionState == ConnectionState.waiting)
                return Center(
                  child: CircularProgressIndicator(),
                );
              else {
                final chatDocs = chatSnapshot.data!.docs;

                // print(futureSnapshot.runtimeType);
                // print(futureSnapshot.data!);
                // print('AAAAAAAAAAAAAAAAAAAAAAAA');
                return ListView.builder(
                    reverse: true,
                    itemCount: chatSnapshot.data!.docs.length,
                    itemBuilder: (ctx, index) => MessageBubble(
                          image: chatDocs[index]['userImage'],
                          username: chatDocs[index]['username'],
                          key: ValueKey(chatDocs[index].id),
                          message: chatDocs[index]['text'],
                          isMe: chatDocs[index]['userID'] ==
                              (futureSnapshot.data! as User).uid,
                        ));
              }
            });
      },
    );
  }
}
