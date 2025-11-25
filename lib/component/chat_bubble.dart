import 'package:flutter/material.dart';

import '../models/message_modal.dart';
import 'constants.dart';

class ChatBubble extends StatelessWidget {
 final Message message;
   const ChatBubble({
    super.key,required this.message
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.only(
            topRight:Radius.circular(16),
            topLeft:Radius.circular(16),
            bottomRight:Radius.circular(16),
          )
      ),
      child:    Text(
       message.message ,
        style: TextStyle(color:Colors.white,fontSize: 16 ),
      ),
    );
  }
}

class ChatBubbleFromFriend extends StatelessWidget {
  final Message message;
  const ChatBubbleFromFriend({
    super.key,required this.message
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
            color:primaryColor,
            borderRadius: BorderRadius.only(
              topRight:Radius.circular(16),
              topLeft:Radius.circular(16),
              bottomLeft:Radius.circular(16),
            )
        ),
        child:    Text(
          message.message ,
          style: TextStyle(color:Colors.white,fontSize: 16 ),
        ),
      ),
    );
  }
}