import 'dart:io';

import 'package:chat_app/component/constants.dart';
import 'package:chat_app/cubits/chat_cubit/chat_cubit.dart';
import 'package:chat_app/helper/show_snak_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../component/chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../cubits/chat_cubit/chat_state.dart';
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  CollectionReference messages = FirebaseFirestore.instance.collection(kCollections);

  TextEditingController controller =TextEditingController();

  final _controller =ScrollController();
  GlobalKey<ScaffoldState>scafoldKey =GlobalKey();
  bool isTextEmpty = true;

  final ImagePicker picker = ImagePicker();
  File? image ;
  XFile? photo ;
  // List<Message>messageList =[];

  Future<void> choosePhoto()async{
    //await picker.pickImage(source: ImageSource.gallery);
    var pickedimage = await picker.pickImage(
        source: ImageSource.gallery);
    if(pickedimage!=null){
      image =File(pickedimage.path);
    }else{}
  }

  @override
  Widget build(BuildContext context) {
final id = FirebaseAuth.instance.currentUser!.uid;
    return   Scaffold(
      key:scafoldKey,
      appBar:AppBar(
  backgroundColor: primaryColor,
  title: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(primaryImage, scale: 1.5),
      const Text(
        'Scholar Chat',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    ],
  ),
  actions: [
    IconButton(
      icon: const Icon(Icons.logout),
      onPressed: () async {
        // Sign out from Firebase
        await FirebaseAuth.instance.signOut();
        // Sign out from Google if used
        // ignore: unused_local_variable
        final googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();

        Navigator.pushReplacementNamed(context, 'Login');
      },
    ),
  ],
),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 16),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  var messageList =BlocProvider.of<ChatCubit>(context).messageList;
                  return ListView.builder(
                    reverse: true,
                    controller: _controller,
                    itemCount: messageList.length,
                    itemBuilder:(context, index) =>  Align(
                        alignment: AlignmentDirectional.topStart,
                        child:  messageList[index].id ==id?ChatBubble(message: messageList[index])
                            :ChatBubbleFromFriend(message:messageList[index])
                    ),
                  );
                },
              ),
            ),
            TextField(
              controller: controller,
              maxLines: 3,
              minLines: 1,
              onChanged: (text) {
               {
                  setState(() {
                    isTextEmpty = text.trim().isEmpty;
                  });
                }
              },
              onSubmitted: (value) {
                if((controller.text).trim().isNotEmpty){
                  BlocProvider.of<ChatCubit>(context).sendMessage(message: value, email:id.toString() );
                  controller.clear();
                  _controller.animateTo(
                      0,
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeIn);
                }else{
                  buildSnackBar(context, "can't sent empty message");
                }
              },
              decoration:  InputDecoration(
                hintText: 'Send Message',
                prefixIcon: IconButton(icon:Icon(Icons.perm_media_outlined),onPressed: (){
                  showModalBottomSheet(
                    context: context,
                    builder: (context) =>
                        SizedBox(
                          height: 100,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:  [
                                const Text(
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  'Please Choose Image ',
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    IconButton(
                                      onPressed: (){
                                        choosePhoto();
                                      }, icon:const Icon(
                                      color: Colors.blue,
                                      Icons.image,
                                    ),
                                    ),
                                    IconButton(
                                      onPressed: (){
                                      },  icon:const Icon(
                                      color: Colors.blue,
                                      Icons.camera_alt,
                                    ),
                                    ),

                                  ],),
                              ],
                            ),
                          ),
                        ),
                  );

                }),
                suffixIcon:isTextEmpty==false?
                IconButton(icon:const Icon(Icons.send),color: primaryColor,onPressed:(){
                  if((controller.text).trim().isNotEmpty){
                    BlocProvider.of<ChatCubit>(context).sendMessage(email:id.toString(),message: controller.text);
                    controller.clear();
                    _controller.animateTo(
                        0,
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeIn);
                  }else{
                    buildSnackBar(context, "can't sent empty message");
                  }
                } ): null,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ) ,
    );
  }



}



