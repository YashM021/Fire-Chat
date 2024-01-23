import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  final User? user;

  const ChatScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('FireChat',style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              _signOut();
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.pink.shade200, // Lighter red
              Colors.yellow.shade200, // Lighter yellow
              Colors.orange.shade200, // Lighter orange
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('messages')
                    .orderBy('timestamp', descending: false)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  var messages = snapshot.data!.docs;

                  List<Widget> messageWidgets = [];
                  for (var message in messages) {
                    var messageText = message['text'];
                    var messageSender = message['sender'];
                    var isCurrentUser = messageSender == widget.user!.email;

                    var messageWidget = MessageWidget(
                      messageSender,
                      messageText,
                      isCurrentUser,
                    );
                    messageWidgets.add(messageWidget);
                  }

                  // Ensure that the ListView scrolls to the latest message
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  });

                  return ListView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8.0),
                    reverse: true, // Show the latest message at the bottom
                    children: messageWidgets,
                  );
                },
              ),
            ),
            const Divider(),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              _sendMessage(_textController.text);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
            ),
            child: const Text('Send',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String message) {
    if (message.trim().isNotEmpty) {
      FirebaseFirestore.instance.collection('messages').add({
        'text': message,
        'sender': widget.user!.email,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _textController.clear();
    }
  }

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pop(context);
  }
}

class MessageWidget extends StatelessWidget {
  final String sender;
  final String text;
  final bool isCurrentUser;

  const MessageWidget(this.sender, this.text, this.isCurrentUser, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment:
        isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isCurrentUser
              ? const SizedBox.shrink()
              : CircleAvatar(
            child: Text(sender[0]),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: isCurrentUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  sender,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: isCurrentUser ? Colors.blueGrey : Colors.grey[300],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: isCurrentUser ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          isCurrentUser
              ? CircleAvatar(
            child: Text(sender[0]),
          )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
