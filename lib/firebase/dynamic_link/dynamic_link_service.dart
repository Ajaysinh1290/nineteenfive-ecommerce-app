import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:nineteenfive_ecommerce_app/models/product.dart';
import 'package:nineteenfive_ecommerce_app/screens/product/item_details.dart';
import 'package:nineteenfive_ecommerce_app/utils/data/static_data.dart';

class DynamicLinkService {
  Future<Uri> createDynamicLink() async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://nineteenfive.page.link',
      link: Uri.parse('https://nineteenfive.page.link/product'),
      androidParameters: AndroidParameters(
        packageName: 'com.example.nineteenfive_ecommerce_app',
        minimumVersion: 1,
      ),
    );
    var dynamicUrl = await parameters.buildShortLink();
    final Uri shortUrl = dynamicUrl.shortUrl;
    return shortUrl;
  }

  Future<Uri> createProductDynamicLink(String productId) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://nineteenfive.page.link',
      link: Uri.parse('https://nineteenfive.page.link/product/?product_id=$productId'),
      androidParameters: AndroidParameters(
        packageName: 'com.example.nineteenfive_ecommerce_app',
        minimumVersion: 1,
      ),
    );
    var dynamicUrl = await parameters.buildShortLink();
    final Uri shortUrl = dynamicUrl.shortUrl;
    print(Uri);
    return shortUrl;
  }

  Future handleDynamicLinks(BuildContext context) async {
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    if(data!=null) {
      _handleDeepLink(data,context);
    }
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLinkData) async {
      _handleDeepLink(dynamicLinkData!,context);
    }, onError: (OnLinkErrorException e) async {
      print('Dynamic Link Failed : ${e.message}');
    });
  }

  void _handleDeepLink(PendingDynamicLinkData data,BuildContext context) {
    final Uri deepLink = data.link;

    print('handle Deep Link | deepLink: $deepLink');
    String? id = deepLink.queryParameters['product_id'];
    late Product product;
    StaticData.products.forEach((element) {
      if(element.productId==id) {
       product = element;
       return;
      }
    });
    Navigator.push(context, MaterialPageRoute(builder: (context)=>ItemDetails(product)));
  }

}
