class BankAccount {
  final int? id;
  final int userId;
  final String bankName;
  final String accountNumber;

  BankAccount({
    this.id,
    required this.userId,
    required this.bankName,
    required this.accountNumber,
  });

  factory BankAccount.fromJson(Map<String, dynamic> json) => BankAccount(
        id: json['id'],
        userId: json['userId'],
        bankName: json['bankName'],
        accountNumber: json['accountNumber'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'bankName': bankName,
        'accountNumber': accountNumber,
      };
}
