# bottom_navigation_builder

A set of widgets that helps you to implement bottom navigation with a navigation history and a transition. Highly flexible and works fine with any kind of custom bottom navigation bar widgets.

## Demo
Cross Fade

![fade in out](https://user-images.githubusercontent.com/45475169/110281143-7b8b4b80-801f-11eb-9a01-29a3485a7bca.gif)

Fade Through (https://material.io/design/motion/the-motion-system.html#fade-through)

![fade through](https://user-images.githubusercontent.com/45475169/110281147-7d550f00-801f-11eb-8a46-fabf47bb5f60.gif)

## Getting Started

The package provides 2 widgets for building UI and 1 controller for navigating. The most common and basic usage would be the following

``` dart
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
      return !_controller.navigateBack();
    },
    child: Scaffold(
      body: BottomNavigationBody(
        controller: _controller,
        transitionType: BottomNavigationTransitionType.none, // BottomNavigationTransitionType.fadeInOut, BottomNavigationTransitionType.fadeThrough,
        children: [
          Container(color: Colors.red),
          Container(color: Colors.blue),
          Container(color: Colors.green),
          Container(color: Colors.yellow),
          Container(color: Colors.orange),
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
```
You have to declare `BottomNavigationController` just like `TextEditingController` and pass it to the `BottomNavigationBody` and `BottomNavigationBarBuilder`. Keep in mind you are responsible for disposing it. The `BottomNavigationController` class is responsible for handling navigation and it contains the history. Call `navigateTo(int index)` to navigate to a certain destination and call `navigateBack()` to navigate back to previous destination. Usually, `navigateBack()` is used only for handling the back button on Android but it works perfectly on all platforms. You can navigate by manually setting the `controller.currentIndex` property but it's not recommended since this does not record the history.


``` dart
BottomNavigationController.of(context) // Null safe
BottomNavigationController.maybeOf(context) // Returns null if not exists
```
You can extract the controller in the decendants of either the `BottomNavigationBody` or the `BottomNavigationBarBuilder` widget.
