import 'package:flutter/material.dart';
import 'package:zap_list_flutter/screens/home_screen.dart';
import 'package:zap_list_flutter/screens/lists_screen.dart';
import 'package:zap_list_flutter/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> navItems = [
      {"page": HomeScreen(), "icon": Icons.home, "label": "Home"},
      {
        "page": ListsScreen(user: user!,),
        "icon": Icons.list,
        "label": "Minhas Listas",
      },
      {
        "page": const Center(child: Text("Notificações")),
        "icon": Icons.notifications,
        "label": "Notificações",
      },
      {
        "page": ProfileScreen(user: user!),
        "icon": Icons.person,
        "label": "Perfil",
      },
    ];

    return Scaffold(
      body: navItems[_selectedIndex]["page"],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFFD6200),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: navItems
            .map(
              (item) => BottomNavigationBarItem(
            icon: Icon(item["icon"]),
            label: item["label"],
          ),
        )
            .toList(),
      ),
    );
  }
}

