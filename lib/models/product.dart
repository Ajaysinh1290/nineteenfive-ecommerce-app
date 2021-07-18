class Product {
  late String productId;
  late String productName;
  late String productCategory;
  late int productPrice;
  int? productMrp;
  late DateTime productCreatedOn;
  late int availableStock;
  List<dynamic>? productSizes = [];
  late List<dynamic> productImages = [];
  List<Map<String, dynamic>>? productRatings = [];
  late String productDescription;
  String? returnTime;

  Product(
      {required this.productId,
      required this.productName,
      required this.productCreatedOn,
      required this.productCategory,
      required this.productPrice,
      this.productMrp,
      this.productSizes,
      required this.availableStock,
      required this.productImages,
      this.productRatings,
      required this.productDescription,
      this.returnTime});

  Product.fromJson(Map<String, dynamic>? data) {
    this.productId = data!['product_id'];
    this.productName = data['product_name'];
    this.availableStock = data['available_stock'];
    this.productCreatedOn = data['product_created_on'].toDate();
    this.productCategory = data['product_category'];
    this.productPrice = data['product_price'];
    this.productMrp = data['product_mrp'];
    this.productDescription = data['product_description'];
    this.productSizes = data['product_sizes'];
    this.productImages = data['product_images'];
    this.productRatings = data['product_ratings'];
    this.returnTime = data['return_time'];
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': this.productId,
      'product_name': this.productName,
      'product_created_on': this.productCreatedOn,
      'product_category': this.productCategory,
      'product_price': this.productPrice,
      'product_mrp': this.productMrp,
      'product_description': this.productDescription,
      'product_sizes': this.productSizes,
      'product_ratings': this.productRatings,
      'product_images': this.productImages,
      'available_stock': this.availableStock,
      'return_time': this.returnTime
    };
  }
}
