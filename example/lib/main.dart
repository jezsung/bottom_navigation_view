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

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
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
          transitionType: BottomNavigationTransitionType.fadeInOut,
          backgroundColor: Colors.lime,
          children: const [
            ColorScreen(color: Colors.red),
            ColorScreen(color: Colors.amber),
            ColorScreen(color: Colors.yellow),
            ColorScreen(color: Colors.green),
            ColorScreen(color: Colors.blue),
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
                BottomNavigationBarItem(
                    label: 'Yellow', icon: Icon(Icons.home)),
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

class ColorScreen extends StatefulWidget {
  const ColorScreen({
    Key? key,
    required this.color,
  }) : super(key: key);

  final Color color;

  @override
  State<ColorScreen> createState() => _ColorScreenState();
}

class _ColorScreenState extends State<ColorScreen> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: widget.color,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$count',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                count++;
              });
            },
            child: const Text('Increment'),
          ),
        ],
      ),
    );
  }
}
