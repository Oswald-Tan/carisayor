class Poin {
  final int id;
  final int poin;
  int? price;
  int? discountPercentage;
  int? originalPrice;

  Poin(
      {required this.id,
      required this.poin,
      this.price,
      this.discountPercentage,
      this.originalPrice});

  factory Poin.fromJson(Map<String, dynamic> json) {
    return Poin(
      id: json['id'],
      poin: json['poin'],
      price: json['price'],
      discountPercentage: json['discountPercentage'],
      originalPrice: json['originalPrice'],
    );
  }
}
