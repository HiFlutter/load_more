import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:load_more/load_more.dart';
import 'package:load_more/src/load_more_view/load_more_view.dart';

void main() {
  test("test widget", () {
    var loadMoreView = LoadMoreView(
      onLoadMore: () async {
        print('loadMore');
      },
      isError: false,
      slivers: [
        SliverList(
            delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Text('$index');
                }))
      ],
      isEmpty: false,
    );
    loadMoreView.createState();
  });
}
