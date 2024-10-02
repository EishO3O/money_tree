import 'package:flutter/material.dart';
import '../add_transaction/new_income_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../financial_report/monthly_screen.dart';
import '../history/history_screen.dart';
import '../settings/settings.dart';
import 'package:intl/intl.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  List<Map<String, dynamic>> expenseCategories = [
    {"title": "SCHOOL", "amount": 100, "budget": 500},
    {"title": "CAR", "amount": 467, "budget": 500},
    {"title": "HEALTH", "amount": 156, "budget": 2000},
    {"title": "GROCERIES", "amount": 637, "budget": 1500},
  ];

  List<Map<String, dynamic>> incomeCategories = [
    {"title": "SCHOOL", "amount": 100, "budget": 500},
    {"title": "CAR", "amount": 467, "budget": 500},
    {"title": "HEALTH", "amount": 156, "budget": 2000},
    {"title": "GROCERIES", "amount": 637, "budget": 1500},
  ];

  Map<String, IconData> categoryIcons = {
    "SCHOOL": Icons.school,
    "CAR": Icons.directions_car,
    "HEALTH": Icons.local_hospital,
    "GROCERIES": Icons.shopping_cart,
  };

  double totalSavings = 4500; // Example total savings amount
  double totalBudget = 5000; // Example total budget for expenses

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavigationBar(context),
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0xFFFFF8ED),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildBudgetSummaryCard(),
              const SizedBox(height: 16),
              _buildBudgetCategoryList("EXPENSES", expenseCategories, true),
              const SizedBox(height: 64),
              _buildSavingsSummaryCard(),
              const SizedBox(height: 16),
              _buildBudgetCategoryList("INCOME", incomeCategories, false),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFFBC29C),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Center(
                child: Text(
                  "BUDGET",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xffE63636)),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: const CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage("lib/images/pfp.jpg"),
            ),
          ),
        ],
      ),
    );
  }

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NewIncomeScreen()),
        );
      },
      backgroundColor: const Color(0xffFFF8ED),
      shape: const CircleBorder(),
      child: const Icon(
        Icons.add,
        size: 40,
        color: Color(0xffE63636),
      ),
    );
  }

  BottomAppBar _buildBottomNavigationBar(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 15.0,
      color: const Color(0xff231F20),
      elevation: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildBottomNavIcon(Icons.home_filled, context, Dashboard()),
          _buildBottomNavIcon(Icons.bar_chart, context, MonthlyReport()),
          const SizedBox(width: 80),
          _buildBottomNavIcon(Icons.history, context, HistoryScreen()),
          _buildBottomNavIcon(Icons.settings_rounded, context, SettingsScreen()),
        ],
      ),
    );
  }

  IconButton _buildBottomNavIcon(IconData icon, BuildContext context, Widget page) {
    return IconButton(
      icon: Icon(icon, color: Colors.white, size: 33),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
    );
  }

  // Build the Budget Summary Card
  Widget _buildBudgetSummaryCard() {
    double spentAmount = expenseCategories.fold(0, (sum, category) => sum + category["amount"]);
    double progress = spentAmount / totalBudget;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Divider(thickness: 1, color: Colors.black54),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    _getCurrentMonth(),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  child: Divider(thickness: 1, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // "Budget" section
            const Text(
              "Budget",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Budget spent/total display
            Text(
              "\$${spentAmount.toStringAsFixed(2)} of \$${totalBudget.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            // Progress bar
            LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0), // Ensure value is between 0 and 1
              backgroundColor: Colors.grey[300],
              color: Colors.teal,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavingsSummaryCard() {
    double progress = totalSavings / 10000; // Example goal for savings

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Savings", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("\$${totalSavings.toStringAsFixed(2)}"),
            LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0), // Ensure value is between 0 and 1
              backgroundColor: Colors.grey[300],
              color: Colors.teal,
            ),
          ],
        ),
      ),
    );
  }

  // Build the Budget Category List
  Widget _buildBudgetCategoryList(String title, List<Map<String, dynamic>> categories, bool isExpense) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...categories.map((category) => _buildCategoryCard(category)).toList(),
        TextButton(
          onPressed: () {
            // Implement add category functionality
            _showAddCategoryDialog(isExpense);
          },
          child: const Text("Add Card", style: TextStyle(color: Colors.teal, fontSize: 16)),
        ),
      ],
    );
  }

  // Build each category card
  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return GestureDetector(
      onLongPress: () {
        _showDeleteConfirmationDialog(category);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(categoryIcons[category["title"]], size: 30),
                  const SizedBox(width: 8),
                  Text(category["title"], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              Row(
                children: [
                  Text("\$${category["amount"]}", style: const TextStyle(fontSize: 16)),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // Implement edit functionality (navigate to edit screen)
                      _showEditCategoryDialog(category);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show dialog to delete category
  void _showDeleteConfirmationDialog(Map<String, dynamic> category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Category"),
          content: Text("Are you sure you want to delete ${category["title"]}?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: const Text("Confirm"),
              onPressed: () {
                setState(() {
                  // Remove the category from the list (Implement logic as per your needs)
                  expenseCategories.remove(category); // Remove from expenseCategories or incomeCategories
                  // Update your state
                });
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }

  // Show dialog to add a new category
  void _showAddCategoryDialog(bool isExpense) {
    // Implement add category functionality here
    // You can use TextFields to get input from the user
  }

  // Show dialog to edit a category
  void _showEditCategoryDialog(Map<String, dynamic> category) {
    // Implement edit functionality here
  }

  // Get current month as a string
  String _getCurrentMonth() {
    return DateFormat('MMMM yyyy').format(DateTime.now());
  }
}
