import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nineteenfive_ecommerce_app/models/category.dart';
import 'package:nineteenfive_ecommerce_app/models/order.dart';
import 'package:nineteenfive_ecommerce_app/models/poster.dart';
import 'package:nineteenfive_ecommerce_app/models/product.dart';
import 'package:nineteenfive_ecommerce_app/models/user_data.dart';
import 'package:nineteenfive_ecommerce_app/utils/data/static_data.dart';

class FirebaseDatabase {
  static Future<void> storeUserData(UserData userData) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userData.userId)
        .set(userData.toJson());
  }

  static Future<UserData> getUserData(String userId) async {
    late UserData userData;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((value) {
            userData = UserData.fromJson(value.data()??{});
    });
    return userData;
  }

  static Future<void> storeProduct(Product? product) async {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(product!.productId)
        .set(product.toJson());
  }

  static Future<void> storeOrder(Order order,bool isNew) async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(order.orderId)
        .set(order.toJson());
   if(isNew) {
     if (StaticData.userData.orders == null) {
       StaticData.userData.orders = [];
     }
     StaticData.userData.orders!.add(order.orderId);
   }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(order.userId)
        .update(StaticData.userData.toJson());
  }

  static Future<List<Product>> fetchProducts() async {
    List<Product> products = [];
    FirebaseFirestore.instance
        .collection('products')
        .snapshots()
        .listen((event) {
      event.docs.forEach((element) {
        print(element.data());
        products.add(Product.fromJson(element.data()));
      });
    });
    return products;
  }

  static Future<void> storeCategory(Category? category) async {
    await FirebaseFirestore.instance
        .collection('categories')
        .doc(category!.categoryId)
        .set(category.toJson());
  }
  static Future<Order> fetchOrder(String orderId) async {
    late Order order;
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(orderId).get().then((value) {
       order = Order.fromJson(value.data());
    });
    return order;
  }

  static Future<void> storePoster(Poster? poster) async {
    await FirebaseFirestore.instance
        .collection('posters')
        .doc(poster!.posterId)
        .set(poster.toJson());
  }

  static Future<List<Category>> fetchCategories() async {
    List<Category> categories = [];
    FirebaseFirestore.instance
        .collection('categories')
        .snapshots()
        .listen((event) {
      event.docs.forEach((element) {
        categories.add(Category.fromJson(element.data()));
      });
    });
    return categories;
  }

  static Future<Product> getProduct(String productId) async {
    late Product product;
    await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .get()
        .then((value) {
      product = Product.fromJson(value.data());
    });
    return product;
  }

  static Future<List<Order>> fetchMyOrders() async {
    late List<Order> orders = [];

    StaticData.userData.orders?.forEach((element) {
      FirebaseFirestore.instance
          .collection('orders')
          .doc(element)
          .snapshots()
          .listen((event) {
            orders.add(Order.fromJson(event.data()));
      });
    });

    return orders;
  }

}
