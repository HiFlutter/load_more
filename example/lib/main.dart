import 'package:flutter/material.dart';
import 'package:flutter_loadmore_any/flutter_loadmore_any.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> list = [];

  Future<void> load() async {
    return Future.value().then((value) => setState(() {
          list.addAll(List.generate(15, (v) => v));
        }));
  }

  @override
  void initState() {
    load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Load More'),
      ),
      body: LoadMoreView(
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
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
