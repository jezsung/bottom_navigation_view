## Motivation

Flutter provides a nice widget for making bottom navigation UI but they don't support navigation and transition. Handling the back button on Android and adding transitions to a bottom navigation widget is not that easy. Just like the `TabBarView` and `TabBarController`, we need a set of widgets and classes that will help implement bottom navigation while being UI agnostics. This package provides a set of widgets and a controller to make it easy to implement back button handling and transitions.

## Demo

Cross Fade

![fade in out](https://user-images.githubusercontent.com/45475169/110281143-7b8b4b80-801f-11eb-9a01-29a3485a7bca.gif)

Fade Through (https://material.io/design/motion/the-motion-system.html#fade-through)

![fade through](https://user-images.githubusercontent.com/45475169/110281147-7d550f00-801f-11eb-8a46-fabf47bb5f60.gif)

## Getting Started

If you have ever worked with the `TabBarView` widget, working with the `BottomNavigationView` widget would be easier. The `BottomNavigationView` widget works almost the same and it follows the same semantics.

First of all, we are going to declare the `BottomNavigationController`. It takes the `SingleTickerProviderMixin` as a required argument just like the `TabBarController`. Don't forget to dispose it in the `dispose()` method.

```dart
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
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
    return Container();
  }
}
```

Next, we are going to use the `BottomNavigationView` and `BottomNavigationIndexedBuilder` widget. Both take the `BottomNavigationController` as the `controller` property. You must give the same instance of the `BottomNavigationController` in order for it to work properly.

The `BottomNavigationView` takes screen widgets as the `children` property. The widgets will become the screen of each bottom navigation. You can give it a `Navigator` widget to make nested navigation.

```dart
BottomNavigationView(
  controller: _controller,
  transitionType: BottomNavigationTransitionType.none,
  children: const [
    ColorScreen(color: Colors.red, name: 'Red'),
    ColorScreen(color: Colors.amber, name: 'Amber'),
    ColorScreen(color: Colors.yellow, name: 'Yellow'),
    ColorScreen(color: Colors.green, name: 'Green'),
    ColorScreen(color: Colors.blue, name: 'Blue'),
  ],
)
```

The `BottomNavigationIndexedBuilder` has the `builder` property. The `builder` function will be called whenever the controller detects a navigation index change and it provides the changed index as the second argument. Here, you can return any kind of customized bottom navigation widget. It's completely UI agnostics and it works well with any bottom navigation widget packages.

```dart
BottomNavigationIndexedBuilder(
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
```

Once you build up your UI, you are ready to call the `goTo()` and `goBack()` functions on the `BottomNavigationController`. Call the `goTo()` function in the `BottomNavigationBar` and the `goBack()` function on the `WillPopScope` widget to handle the back button on Android.
If you want to change the transition animation, specify the `transitionType` with one of the `BottomNavigationTransitionType` enum values. It has the `fadeInOut` and `fadeThrough` value. You can see how it looks on the demo.

The package also provides the `DefaultBottomNavigationController` just like the `DefaultTabBarController`.

```dart
class Home extends StatelessWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultBottomNavigationController(child: ...)
  }
}
```

Take a look at the complete code below.

```dart
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
          transitionType: BottomNavigationTransitionType.none,
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
```
