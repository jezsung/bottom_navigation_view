import 'package:bottom_navigation_view/bottom_navigation_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'bottom_navigation_view example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.black,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late final BottomNavigationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = BottomNavigationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _controller.goBack();
        return false;
      },
      child: Scaffold(
        body: BottomNavigationView(
          controller: _controller,
          transitionType: BottomNavigationTransitionType.fadeThrough,
          backgroundColor: Colors.lime,
          children: const [
            ColorScreen(color: Colors.red, name: 'Red'),
            ColorScreen(color: Colors.amber, name: 'Amber'),
            ColorScreen(color: Colors.yellow, name: 'Yellow'),
            ColorScreen(color: Colors.green, name: 'Green'),
            ColorScreen(color: Colors.blue, name: 'Blue'),
          ],
        ),
        bottomNavigationBar: BottomNavigationIndexedBuilder(
          controller: _controller,
          builder: (context, index, child) {
            return BottomNavigationBar(
              currentIndex: index,
              onTap: (index) {
                _controller.goTo(index);
              },
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(label: 'Red', icon: Icon(Icons.home)),
                BottomNavigationBarItem(label: 'Amber', icon: Icon(Icons.home)),
                BottomNavigationBarItem(label: 'Yellow', icon: Icon(Icons.home)),
                BottomNavigationBarItem(label: 'Green', icon: Icon(Icons.home)),
                BottomNavigationBarItem(label: 'Blue', icon: Icon(Icons.home)),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ColorScreen extends StatelessWidget {
  const ColorScreen({
    Key? key,
    required this.color,
    required this.name,
  }) : super(key: key);

  final Color color;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: color,
      child: Text(
        name,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
