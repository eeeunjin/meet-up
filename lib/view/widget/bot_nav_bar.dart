import 'package:flutter/material.dart';
import 'package:meet_up/view_model/bot_nav_view_model.dart';
import 'package:provider/provider.dart';

class BotNavBar extends StatelessWidget {
  const BotNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomNavViewModel =
        Provider.of<BottomNavigationBarViewModel>(context);
    return BottomNavigationBar(
      currentIndex: bottomNavViewModel.currentIndex,
      onTap: (index) {
        bottomNavViewModel.updateCurrentPage(index);
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Meet',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chat',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.login), label: 'login')
      ],
    );
  }
}
