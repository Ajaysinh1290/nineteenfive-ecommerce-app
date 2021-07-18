import 'package:nineteenfive_ecommerce_app/models/address.dart';
import 'package:nineteenfive_ecommerce_app/models/cart.dart';
import 'package:nineteenfive_ecommerce_app/models/search_history.dart';

class UserData {
  late String userId;
  late String email;
  String? mobileNumber;
  List<dynamic>? addresses = [];
  late String userName;
  late String? userProfilePic;
  List<Cart>? cart = [];
  List<dynamic>? orders = [];
  List<dynamic>? likedProducts = [];
  List<dynamic>? searchHistory = [];

  UserData(
      {required this.userId,
      required this.email,
      this.mobileNumber,
      this.addresses,
      required this.userName,
      this.userProfilePic,
      this.cart,
      this.orders,
      this.likedProducts,
      this.searchHistory});

  UserData.fromJson(Map<String, dynamic> data) {
    this.userId = data['user_id'];
    this.email = data['email'];
    this.mobileNumber = data['mobile_number'];
    List<dynamic> addressesList = data['addresses'];
    addressesList.forEach((address) {
      addresses!.add(Address.fromJson(address));
    });
    this.userName = data['user_name'];
    this.userProfilePic = data['user_profile_pic'];
    List<dynamic> cartList = data['cart'];
    cartList.forEach((cartItem) {
      cart!.add(Cart.fromJson(cartItem));
    });
    this.orders = data['orders'];
    this.likedProducts = data['liked_products'];
    List<dynamic> searchHistoryList = data['search_history'];
    searchHistoryList.forEach((query) {
      searchHistory!.add(SearchHistory.fromJson(query));
    });
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> addressesList = [];
    if (addresses != null) {
      addresses!.forEach((address) {
        addressesList.add(address.toJson());
      });
    }

    List<Map<String, dynamic>> cartList = [];

    if (cart != null) {
      cart!.forEach((cartItem) {
        cartList.add(cartItem.toJson());
      });
    }

    List<Map<String, dynamic>> searchHistoryList = [];

    if (searchHistory != null) {
      searchHistory!.forEach((query) {
        searchHistoryList.add(query.toJson());
      });
    }

    return {
      'user_id': this.userId,
      'email': this.email,
      'mobile_number': this.mobileNumber,
      'addresses': addressesList,
      'user_name': this.userName,
      'user_profile_pic': this.userProfilePic,
      'cart': cartList,
      'orders': this.orders,
      'liked_products': this.likedProducts,
      'search_history': searchHistoryList
    };
  }
}
