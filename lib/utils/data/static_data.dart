import 'package:nineteenfive_ecommerce_app/models/category.dart';
import 'package:nineteenfive_ecommerce_app/models/product.dart';
import 'package:nineteenfive_ecommerce_app/models/promo_code.dart';
import 'package:nineteenfive_ecommerce_app/models/user_data.dart';

class StaticData {
  static late List<Category> categoriesList;
  static late UserData userData;
  static late List<Product> products;
  // static Map<String,int> promoCodes = {
  //   "HOLI2021" : 40,
  //   "DIWALI2020" : 100,
  //   "INDEPENDENCEDAY2021" : 50
  // };
  static late List<PromoCode> promoCodes;
  static late int shippingCharge;
}