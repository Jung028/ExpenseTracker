import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For encoding and decoding data
import 'add_expense_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ExpenseHomePage(),
    );
  }
}

class ExpenseHomePage extends StatefulWidget {
  @override
  _ExpenseHomePageState createState() => _ExpenseHomePageState();
}

class _ExpenseHomePageState extends State<ExpenseHomePage> {
  List<Map<String, dynamic>> _expenses = [];

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  // Load expenses from SharedPreferences
  Future<void> _loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final String? expensesData = prefs.getString('expenses');
    if (expensesData != null) {
      final List<dynamic> decodedData = json.decode(expensesData);
      setState(() {
        _expenses = decodedData.map((e) => Map<String, dynamic>.from(e)).toList();
      });
    }
  }

  // Save expenses to SharedPreferences
  Future<void> _saveExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(_expenses);
    prefs.setString('expenses', encodedData);
  }

  // Add or Edit Expense
  void _addOrEditExpense(Map<String, dynamic> expense, [int? index]) {
    if (index != null) {
      // Edit the expense if an index is provided
      setState(() {
        _expenses[index] = expense;
      });
    } else {
      // Add a new expense
      setState(() {
        _expenses.add(expense);
      });
    }
    _saveExpenses(); // Save to SharedPreferences after modifying the list
  }

  // Delete Expense
  void _deleteExpense(int index) {
    setState(() {
      _expenses.removeAt(index);
    });
    _saveExpenses(); // Save after deleting an expense
  }

  // Calculate the total expense
  double _getTotalExpenses() {
    double total = 0.0;
    for (var expense in _expenses) {
      total += expense['amount'];
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Expense Tracker')),
      body: Column(
        children: [
          // Display total expenses
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total Expenses: \$${_getTotalExpenses().toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // List of expenses
          Expanded(
            child: ListView.builder(
              itemCount: _expenses.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('${_expenses[index]['name']} - \$${_expenses[index]['amount']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Edit button
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          final editedExpense = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddExpenseScreen(
                                initialName: _expenses[index]['name'],
                                initialAmount: _expenses[index]['amount'],
                              ),
                            ),
                          );

                          if (editedExpense != null) {
                            _addOrEditExpense(editedExpense, index); // Edit the expense
                          }
                        },
                      ),
                      // Delete button
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteExpense(index); // Delete the expense
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newExpense = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddExpenseScreen()),
          );

          if (newExpense != null) {
            _addOrEditExpense(newExpense); // Add a new expense
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
