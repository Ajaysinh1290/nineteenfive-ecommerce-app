import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  String date = '';

  @override
  Widget build(BuildContext context) {
    date = '';
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userData.userId)
          .collection('chat')
          .snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        List<ChatData> chats = [];
        if (snapshot.hasData) {
          List data = snapshot.data.docs;
          data.forEach((element) {
            chats.add(ChatData.fromJson(element.data()));
          });
        }
        return !snapshot.hasData
            ? Container()
            : ListView.builder(
                controller: scrollController,
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  ChatData chatData = chats[index];
                  Color textColor =
                      chatData.isSendByUser ? Colors.black : Colors.white;
                  Color containerColor = chatData.isSendByUser
                      ? ColorPalette.blue
                      : Colors.grey[600]!.withOpacity(0.1);
                  Alignment bubbleAlignment = chatData.isSendByUser
                      ? Alignment.centerLeft
                      : Alignment.centerRight;
                  bool isSameDate = Constants.onlyDateFormat
                          .format(chatData.messageDateTime) ==
                      date;
                  if (!isSameDate) {
                    date = Constants.onlyDateFormat
                        .format(chatData.messageDateTime);
                  }
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (!isSameDate)
                            Container(
                              decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(
                                      10)),
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 15),
                              margin: EdgeInsets.symmetric(vertical: 15),
                              child: Text(
                                Constants.onlyDateFormat
                                            .format(DateTime.now()) ==
                                        date
                                    ? 'Today'
                                    : date,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          Container(
                            alignment: bubbleAlignment,
                            margin: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 20),
                            width: double.infinity,
                            constraints: BoxConstraints(
                                maxWidth: constraints.maxWidth * 0.9),
                            child: Column(
                              crossAxisAlignment: chatData.isSendByUser
                                  ? CrossAxisAlignment.start
                                  : CrossAxisAlignment.end,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        10),
                                    color: containerColor,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 20),
                                  child: Text(
                                    chatData.message,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .copyWith(
                                            color: textColor,
                                            fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    Constants.onlyTimeFormat
                                        .format(chatData.messageDateTime),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .copyWith(
                                            fontSize: 10,
                                            color: Colors.grey[200],
                                            letterSpacing: 1.2,
                                            fontFamily: GoogleFonts.poppins()
                                                .fontFamily),
                                  ),
                                )
                              ],
                            ),
                          ),
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
