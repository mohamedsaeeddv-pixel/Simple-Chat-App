import 'package:chat_app/models/message_modal.dart';

abstract class ChatState {}
class ChatInitial extends ChatState {}
class ChatSubmit extends ChatState {}
class ChatSuccess extends ChatState {
  List<Message>messages=[];
  ChatSuccess({required this.messages});

}

