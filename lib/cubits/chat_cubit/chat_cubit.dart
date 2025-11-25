import 'package:bloc/bloc.dart';
import 'package:chat_app/models/message_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../component/constants.dart';
import 'chat_state.dart';
class ChatCubit extends Cubit<ChatState> {
  CollectionReference messages = FirebaseFirestore.instance.collection(kCollections);
  List<Message>messageList=[];
  ChatCubit() : super(ChatInitial());
  void submit({required bool isTextEmpty,required String text}){
    isTextEmpty = text.trim().isEmpty;
    emit(ChatSubmit());
  }
  void sendMessage({required String message , required String email}){
        final uid = FirebaseAuth.instance.currentUser!.uid;

    messages.add({
      kMessage:message,
      kOrderAt:DateTime.now(),
      'id':uid,

    });
  }
  void getMessage(){
    messages.orderBy(kOrderAt,descending: true).snapshots().listen((event)
    {
      messageList.clear();
      for(var doc in event.docs){
        messageList.add(Message.fromJson(doc));
      }
      emit(ChatSuccess(messages: messageList));
    });
  }

}
