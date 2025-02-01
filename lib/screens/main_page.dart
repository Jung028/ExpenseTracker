import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../widgets/app_menu.dart';
import 'expense_list_screen.dart';
import '../services/expense_service.dart';  // Import the expense service
import '../models/expense.dart';  // Import the expense model

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  double totalBalance = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchExpenses();
  }

  // Fetch expenses from the backend API using the ExpenseService
  Future<void> _fetchExpenses() async {
    try {
      ExpenseService expenseService = ExpenseService();
      List<Expense> expenses = await expenseService.fetchExpenses();

      // Debug print to check fetched expenses
      print("Fetched Expenses: $expenses");

      // Calculate the total balance by summing up the expense amounts
      double total = 0.0;
      for (var expense in expenses) {
        print("Expense Amount: ${expense.amount}");  // Debug print to check each expense amount
        total += expense.amount;
      }

      setState(() {
        totalBalance = total;
        isLoading = false; // Set loading to false once data is fetched
      });
      print("Total Balance: $totalBalance"); // Debug print for the total balance
    } catch (e) {
      print("Error fetching expenses: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expense Tracker"),
      ),
      drawer: AppMenu(), // Use AppMenu here
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            isLoading
                ? CircularProgressIndicator() // Show loading indicator while fetching data
                : _buildBalanceSection(),
            SizedBox(height: 20),
            ExpenseListScreen(),  // This can be modified to show the expenses
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Total Balance",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          Text(
            "\$${totalBalance.toStringAsFixed(2)}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
