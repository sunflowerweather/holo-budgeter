class Transaction {
  final double amount;
  final String category;
  final String name;
  final bool isIncome;
  final int timestamp;

  Transaction({
    required this.amount,
    required this.category,
    required this.name,
    required this.isIncome,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'category': category,
      'name': name,
      'isIncome': isIncome,
      'timestamp': timestamp,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String? ?? '',
      name: json['name'] as String? ?? '',
      isIncome: json['isIncome'] as bool? ?? false,
      timestamp: json['timestamp'] as int? ?? 0,
    );
  }
}