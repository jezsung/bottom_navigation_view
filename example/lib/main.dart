import 'package:bottom_navigation_builder/bottom_navigation_builder.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'bottom_navigation_builder example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<NavigatorState> _navigatorKey1 = GlobalKey<NavigatorState>();

  final BottomNavigationController _controller = BottomNavigationController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        /// You have to handle nested navigation pop manually.
        bool didPop = false;
        if (_controller.currentIndex == 4) {
          didPop = await _navigatorKey1.currentState!.maybePop();
        }
        if (!didPop) {
          return !_controller.navigateBack();
        }
        return false;
      },
      child: Scaffold(
        body: BottomNavigationBody(
          controller: _controller,
          transitionType: BottomNavigationTransitionType.fadeThrough,
          children: [
            Container(color: Colors.red),
            Container(color: Colors.blue),
            Container(color: Colors.green),
            Container(color: Colors.yellow),

            /// Declare Navigator for nested navigation.
            Navigator(
              key: _navigatorKey1,
              initialRoute: 'first',
              onGenerateRoute: (settings) {
                return MaterialPageRoute(
                  builder: (context) {
                    switch (settings.name) {
                      case 'first':
                        return Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'second');
                            },
                            child: Text('Go to second page'),
                          ),
                        );
                      case 'second':
                        return Center(child: Text('Second'));
                      default:
                        throw UnimplementedError();
                    }
                  },
                );
              },
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBarBuilder(
          controller: _controller,
          builder: (context, index, child) {
            return BottomNavigationBar(
              currentIndex: index,
              type: BottomNavigationBarType.fixed,
              onTap: _controller.navigateTo,
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.one_k), label: 'First'),
                BottomNavigationBarItem(icon: Icon(Icons.two_k), label: 'Second'),
                BottomNavigationBarItem(icon: Icon(Icons.three_k), label: 'Third'),
                BottomNavigationBarItem(icon: Icon(Icons.four_k), label: 'Fourth'),
                BottomNavigationBarItem(icon: Icon(Icons.five_k), label: 'Fifth'),
              ],
            );
          },
        ),
      ),
    );
  }
}
