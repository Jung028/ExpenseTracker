import 'package:flutter/material.dart';

class AddExpenseScreen extends StatefulWidget {
  final String? initialName;
  final double? initialAmount;

  AddExpenseScreen({this.initialName, this.initialAmount});

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  String _expenseName = '';
  double _expenseAmount = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.initialName != null && widget.initialAmount != null) {
      _expenseName = widget.initialName!;
      _expenseAmount = widget.initialAmount!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialName == null ? 'Add Expense' : 'Edit Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _expenseName,
                decoration: InputDecoration(labelText: 'Expense Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid name';
                  }
                  return null;
                },
                onChanged: (value) {
                  _expenseName = value;
                },
              ),
              TextFormField(
                initialValue: _expenseAmount.toString(),
                decoration: InputDecoration(labelText: 'Expense Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty || double.tryParse(value) == null) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
                onChanged: (value) {
                  _expenseAmount = double.parse(value);
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Send data back to parent to save the expense
                    Navigator.pop(context, {'name': _expenseName, 'amount': _expenseAmount});
                  }
                },
                child: Text('Save Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
