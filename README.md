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

This will add a line like this to your package's pubspec.yaml (and run an implicit flutter pub get):
```dart
    dependencies:
      flutter_loadmore_any: ^0.0.1
```
Import it
Now in your Dart code, you can use:
```dart
    import 'package:flutter_loadmore_any/flutter_loadmore_any.dart';
```

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
在slivers中添加普通widget时可以使用SliverToBoxAdapter转换一下
```dart
    SliverToBoxAdapter(
      child: Text('Test'))
```


