import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nineteenfive_ecommerce_app/models/chat_data.dart';
import 'package:nineteenfive_ecommerce_app/models/user_data.dart';
import 'package:nineteenfive_ecommerce_app/utils/color_palette.dart';
import 'package:nineteenfive_ecommerce_app/utils/constants.dart';
import 'package:nineteenfive_ecommerce_app/utils/data/static_data.dart';
import 'package:nineteenfive_ecommerce_app/widgets/image/image_network.dart';

import 'chat_bubbles.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    messageController.text = '';
  }
  void sendMessage() {
    String message = messageController.text.trim();
    if(message.isNotEmpty) {
      ChatData chatData = ChatData(
          chatId: DateTime.now().millisecondsSinceEpoch.toString(),
          message: message,
          isSeenByReceiver: false,
          isSendByUser: false,
          messageDateTime: DateTime.now()
      );
      FirebaseFirestore.instance.collection('users').doc(StaticData.userData.userId).collection('chat').doc(chatData.chatId).set(chatData.toJson());
      setState((){

      });
    }
    messageController.text = '';

  }
  @override
  Widget build(BuildContext context) {
    messageController.text = '';

    return Column(
      children: [
        Row(
          children: [
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: IconButton(
                  icon: Icon(
                      Icons.arrow_back,
                    color: Theme.of(context).accentColor,
                  ),
                  iconSize: 22,
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
              ),
            Hero(
              tag: StaticData.userData.userId,
              child: StaticData.userData.userProfilePic != null
                  ? ClipOval(
                      child: ImageNetwork(
                        imageUrl: StaticData.userData.userProfilePic ?? '',
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).scaffoldBackgroundColor),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              StaticData.userData.userName,
              style: Theme.of(context).textTheme.headline5,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        SizedBox(height: 15,),
        Container(height: 1,color: Colors.white12,width: double.infinity,),
        SizedBox(height: 5,),
        Expanded(
            child: ChatBubbles(
          userData: StaticData.userData,
        )),
        Container(
          margin: EdgeInsets.all(20.0),
          padding: EdgeInsets.all(7.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, -4),
                    color: Colors.black12,
                    blurRadius: 10)
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 50,
                    maxHeight: 150
                  ),
                  child: TextField(
                    minLines: 1,
                    maxLines: 10,
                    controller: messageController,
                    style: Theme.of(context).textTheme.headline5,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle: Theme.of(context).textTheme.headline5!.copyWith(color: ColorPalette.grey),
                        hintText: 'Type Something...'),
                  ),
                ),
              ),
              GestureDetector(
                onTap: sendMessage,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(colors: [
                        ColorPalette.blue,
                        ColorPalette.darkBlue,
                      ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
                  child: Transform.rotate(
                    angle: -45 * pi / 180,
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
