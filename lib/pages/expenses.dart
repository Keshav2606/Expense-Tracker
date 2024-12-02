import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/pages/new_expense.dart';
import 'package:expense_tracker/utils/expenses_list.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> registeredExpenses = [
    // Expense(
    //     title: 'Flutter Course',
    //     amount: 499,
    //     date: DateTime.now(),
    //     category: Category.work),
  ];

  void _addExpenseData(Expense expense) {
    setState(() {
      registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    int expenseIndex = registeredExpenses.indexOf(expense);
    setState(() {
      registeredExpenses.remove(expense);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense Removed Successfully!!'),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                registeredExpenses.insert(expenseIndex, expense);
              });
            }),
      ),
    );
  }

  _openModalBottomSheet() {
    return showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: true,
        context: context,
        builder: (context) => NewExpense(onAddExpense: _addExpenseData));
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('No Expenses Added. Try Adding Some Expenses.'),
    );

    if (registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        title: const Text(
          'Expense Tracker',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            onPressed: _openModalBottomSheet,
            icon: const Icon(Icons.add),
          ),
          const SizedBox(
            width: 6,
          )
        ],
      ),
      body: Column(
        children: [
          Chart(expenses: registeredExpenses),
          Expanded(
            child: mainContent,
          ),
        ],
      ),
    );
  }
}
