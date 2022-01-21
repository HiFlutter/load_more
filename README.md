<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

## screenshot

<img width="270" height="480" src="https://github.com/HiFlutter/load_more/blob/master/iamges/device-2022-01-20-143856.gif"/>

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

```dart
  LoadMoreView(
    onLoadMore: () => load(), 
    isEmpty: false,
    isError: false,
    duration: 500,
    slivers: [
    SliverList(
    delegate:
    SliverChildBuilderDelegate((BuildContext context, int index) {
      return Container(
        child: Text(list[index].toString()),
        height: 40.0,
        alignment: Alignment.center,
      );
  }, childCount: list.length)),
  ],
  ),
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to 
contribute to the package, how to file issues, what response they can expect 
from the package authors, and more.
