import 'package:flutter/material.dart';
import 'package:port_karo/res/constant_color.dart';
import 'package:port_karo/view/account/account.dart';
import 'package:port_karo/view/home/home.dart';
import 'package:port_karo/view/order/order.dart';
import 'package:port_karo/view/payment/payment.dart';

class BottomNavigationPage extends StatefulWidget {
  final int initialIndex;
  final Widget? page;
  const BottomNavigationPage({super.key, this.initialIndex = 0, this.page});

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const OrderPage(),
    const PaymentsPage(),
    const AccountPage(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
          return false;
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xfff6f6f6),
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
        bottomNavigationBar: Container(
          height: 65, // Reduced from 80 to 65
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, "Home", 0),
              _buildNavItem(Icons.receipt_long, "Orders", 1),
              _buildNavItem(Icons.account_balance_wallet, "Payments", 2),
              _buildNavItem(Icons.account_circle, "Account", 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color: _selectedIndex == index ? PortColor.gold : Colors.black54,
          ),
          const SizedBox(height: 4), // Reduced spacing
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: _selectedIndex == index ? PortColor.gold : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}