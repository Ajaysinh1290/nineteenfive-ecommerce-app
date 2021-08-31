import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nineteenfive_ecommerce_app/models/chat_data.dart';
import 'package:nineteenfive_ecommerce_app/utils/color_palette.dart';
import 'package:nineteenfive_ecommerce_app/utils/data/static_data.dart';

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
    if (message.isNotEmpty) {
      ChatData chatData = ChatData(
          chatId: DateTime.now().millisecondsSinceEpoch.toString(),
          message: message,
          isSeenByReceiver: false,
          isSendByUser: true,
          messageDateTime: DateTime.now());
      FirebaseFirestore.instance
          .collection('users')
          .doc(StaticData.userData.userId)
          .collection('chat')
          .doc(chatData.chatId)
          .set(chatData.toJson());
    }
    messageController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    messageController.text = '';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Align(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: ScreenUtil().setWidth(25),
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Chat',
            style: Theme.of(context).appBarTheme.textTheme!.headline1),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ChatBubbles(
              userData: StaticData.userData,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Spacer(),
                Container(
                  margin: EdgeInsets.all(20.0),
                  padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(ScreenUtil().radius(18)),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, -4),
                            color: Colors.black12,
                            blurRadius: 20)
                      ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              minHeight: ScreenUtil().setWidth(50),
                              maxHeight: ScreenUtil().setWidth(150)),
                          child: TextField(
                            minLines: 1,
                            maxLines: 10,
                            controller: messageController,
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(color: Colors.black),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintStyle:
                                    Theme.of(context).textTheme.headline6,
                                hintText: 'Type Something...'),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: sendMessage,
                        child: Container(
                          width: 55.sp,
                          height: 55.sp,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  ScreenUtil().radius(15)),
                              gradient: LinearGradient(
                                  colors: [
                                    ColorPalette.blue,
                                    ColorPalette.darkBlue.withOpacity(0.7),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight)),
                          child: Transform.rotate(
                            angle: -45 * pi / 180,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 5, bottom: 0),
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 28.sp,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
