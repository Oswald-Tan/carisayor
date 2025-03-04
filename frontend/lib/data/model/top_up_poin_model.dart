class TopUpPoin {
  final int id;
  final int userId;
  final int points;
  final int price;
  final String date;
  final String bankName;
  final String status;

  TopUpPoin({
    required this.id,
    required this.userId,
    required this.points,
    required this.price,
    required this.date,
    required this.bankName,
    required this.status,
  });

  factory TopUpPoin.fromJson(Map<String, dynamic> json) {
    return TopUpPoin(
      id: json['id'],
      userId: json['userId'],
      points: json['points'],
      price: json['price'],
      date: json['created_at'],
      bankName: json['bankName'],
      status: json['status'],
    );
  }
}
