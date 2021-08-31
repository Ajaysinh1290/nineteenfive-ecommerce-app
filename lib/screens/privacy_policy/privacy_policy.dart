import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nineteenfive_ecommerce_app/widgets/dialog/my_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  final Function? onDrawerClick;

  PrivacyPolicyScreen({Key? key, this.onDrawerClick}) : super(key: key);

  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
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
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              widget.onDrawerClick!();
            }
          },
        ),
        title: Text('Privacy Policy',
            style: Theme.of(context).appBarTheme.textTheme!.headline1),
        centerTitle: true,
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            widget.onDrawerClick!();
          }
          return false;
        },
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 10),
            child: FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('admin')
                  .doc('privacy_policy')
                  .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                String? privacyPolicy;
                if (snapshot.hasData) {
                  privacyPolicy = snapshot.data!.data()!['privacy_policy'];
                }
                return Html(
                  data: privacyPolicy ?? '',
                  onLinkTap: (String? url, _, attributes, element) async {
                    if (await canLaunch(url!)) {
                      await launch(
                        url,
                      );
                    } else {
                      MyDialog.showMyDialog(
                          context, "Could not launch mail id..!");
                    }
                  },
                );
                // return Text(about??"",style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.black),);
              },
            ),
          ),
        ),
      ),
    );
  }
}
