import 'package:flutter/material.dart';

import 'navigation_bar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        bottomNavigationBar: NavigationBar(
          items: [
            NavigationBarItem(
              icon: Icons.home,
              label: 'Home',
              color: Colors.red,
            ),
            NavigationBarItem(
              icon: Icons.favorite,
              label: 'Favorite',
              color: Colors.orange,
            ),
            NavigationBarItem(
              icon: Icons.search,
              label: 'Search',
              color: Colors.green,
            ),
            NavigationBarItem(
              icon: Icons.person,
              label: 'Profile',
              color: Colors.blue,
            ),
          ],
          itemPadding: const EdgeInsets.all(18.0),
        ),
        body: Container(
          color: Colors.green,
        ),
      ),
    );
  }
}
