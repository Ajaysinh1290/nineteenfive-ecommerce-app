import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nineteenfive_ecommerce_app/models/chat_data.dart';
import 'package:nineteenfive_ecommerce_app/models/user_data.dart';
import 'package:nineteenfive_ecommerce_app/utils/color_palette.dart';
import 'package:nineteenfive_ecommerce_app/utils/constants.dart';

class ChatBubbles extends StatefulWidget {
  final UserData userData;

  const ChatBubbles({Key? key, required this.userData}) : super(key: key);

  @override
  _ChatBubblesState createState() => _ChatBubblesState();
}

class _ChatBubblesState extends State<ChatBubbles> {
  ScrollController scrollController = ScrollController();

  late Stream getAllChats;

  refreshScreen() async {
    Future.delayed(Duration(milliseconds: 100))
        .then((value) => setState(() {}));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllChats = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userData.userId)
        .collection('chat')
        .orderBy('message_date_time', descending: true)
        .snapshots();
  }

  seenByUser(ChatData chatData) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userData.userId)
        .collection('chat')
        .doc(chatData.chatId)
        .set(chatData.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getAllChats,
      builder: (context, AsyncSnapshot snapshot) {
        Map<String, List<ChatData>> chatsList = {};
        List<ChatData> unreadChats = [];
        if (snapshot.hasData) {
          List data = snapshot.data.docs;
          data.forEach((element) {
            ChatData chatData = ChatData.fromJson(element.data());

            String dateKey =
                Constants.onlyDateFormat.format(chatData.messageDateTime);

            if (chatsList.containsKey(dateKey)) {
              chatsList[dateKey]!.add(chatData);
            } else {
              chatsList[dateKey] = [chatData];
            }
            if (!chatData.isSendByUser && !chatData.isSeenByReceiver) {
              chatData.isSeenByReceiver = true;
              unreadChats.add(chatData);
            }
          });
          unreadChats.forEach((element) {
            seenByUser(element);
          });
          chatsList.keys.forEach((element) {
            chatsList[element] = chatsList[element]!.reversed.toList();
          });
          if (scrollController.hasClients) {
            scrollController.jumpTo(scrollController.position.minScrollExtent);
          }
        }
        return !snapshot.hasData
            ? Container()
            : ListView.builder(
                reverse: true,
                controller: scrollController,
                itemCount: chatsList.keys.length,
                padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(100)),
                itemBuilder: (context, index) {
                  String dateOfChat = chatsList.keys.toList()[index];

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                              Constants.onlyDateFormat.format(DateTime.now()) ==
                                      dateOfChat
                                  ? 'Today'
                                  : dateOfChat,
                              style: Theme.of(context).textTheme.headline6),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: chatsList[dateOfChat]!.map((chatData) {
                                LinearGradient containerColor =
                                    !chatData.isSendByUser
                                        ? ColorPalette.blueGradient
                                        : LinearGradient(colors: [
                                            Colors.grey[100]!,
                                            Colors.grey[100]!
                                          ]);
                                Alignment bubbleAlignment =
                                    !chatData.isSendByUser
                                        ? Alignment.centerLeft
                                        : Alignment.centerRight;
                                return Container(
                                  alignment: bubbleAlignment,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 20),
                                  width: double.infinity,
                                  constraints: BoxConstraints(
                                      maxWidth: constraints.maxWidth),
                                  child: Column(
                                    crossAxisAlignment: chatData.isSendByUser
                                        ? CrossAxisAlignment.end
                                        : CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                gradient: containerColor),
                                            constraints: BoxConstraints(
                                                maxWidth:
                                                    constraints.maxWidth * 0.7),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 15, horizontal: 20),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  right: chatData.isSendByUser
                                                      ? 10
                                                      : 0),
                                              child: Text(chatData.message,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline6!
                                                      .copyWith(
                                                          color: Colors.black)),
                                            ),
                                          ),
                                          if (chatData.isSendByUser)
                                            Positioned(
                                              bottom: 5,
                                              right: 5,
                                              child: Icon(
                                                chatData.isSeenByReceiver
                                                    ? Icons.done_all
                                                    : Icons.done,
                                                color: chatData.isSeenByReceiver
                                                    ? ColorPalette.darkBlue
                                                    : Colors.grey[400],
                                                size: 20.sp,
                                              ),
                                            )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              chatData.isSendByUser
                                                  ? MainAxisAlignment.end
                                                  : MainAxisAlignment.start,
                                          children: [
                                            Text(
                                                Constants.onlyTimeFormat.format(
                                                    chatData.messageDateTime),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6!
                                                    .copyWith(
                                                        color: Colors.grey[400],
                                                        fontSize: 14.sp,
                                                        fontFamily: GoogleFonts
                                                                .openSans()
                                                            .fontFamily,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                            SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }).toList())
                        ],
                      );
                    },
                  );
                },
              );
      },
    );
  }
}
