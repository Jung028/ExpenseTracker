class Expense {
  final String name;
  final double amount;
  final String date;

  Expense({required this.name, required this.amount, required this.date});

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      name: json['name'],
      amount: json['amount'],
      date: json['date'],
    );
  }
}
