class Poster {
  late String posterId;
  late String imageUrl;
  late String categoryId;
  //Top or bottom
  late String position;
  int? minAmount;
  int? maxAmount;
  int? maxOff;
  int? minOff;

  Poster(
      {required this.imageUrl,
      required this.categoryId,
      required this.position,
      required this.posterId,
      this.minAmount,
      this.maxAmount,
      this.maxOff,
      this.minOff});

  Poster.fromJson(Map<String, dynamic> data) {
    imageUrl = data['image_url'];
    categoryId = data['category_id'];
    position = data['position'];
    maxAmount = data['max_amount'];
    minAmount = data['min_amount'];
    maxOff = data['max_off'];
    minOff = data['min_off'];
    posterId = data['poster_id'];
  }

  Map<String, dynamic> toJson() {
    return {
      'image_url': this.imageUrl,
      'category_id': this.categoryId,
      'position': this.position,
      'max_amount': this.maxAmount,
      'min_amount': this.minAmount,
      'max_off': this.maxOff,
      'min_off': this.minOff,
      'poster_id' : this.posterId
    };
  }
}
