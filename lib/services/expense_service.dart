import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/expense.dart';

class ExpenseService {
  static const String apiUrl = 'http://localhost:5162/api/expenses';

  Future<List<Expense>> fetchExpenses() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((expense) => Expense.fromJson(expense)).toList();
    } else {
      throw Exception('Failed to load expenses');
    }
  }
}
