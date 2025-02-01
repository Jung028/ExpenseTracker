import 'package:flutter/material.dart';
import '../services/expense_service.dart';
import '../models/expense.dart';

class ExpenseListScreen extends StatefulWidget {
  @override
  _ExpenseListScreenState createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  late Future<List<Expense>> expenses;
  final expenseService = ExpenseService();

  @override
  void initState() {
    super.initState();
    expenses = expenseService.fetchExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Expense>>(
      future: expenses,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No expenses found.'));
        } else {
          return Expanded(
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final expense = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(expense.name),
                    subtitle: Text(expense.date),
                    trailing: Text('\$${expense.amount.toStringAsFixed(2)}'),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
