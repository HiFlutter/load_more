import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_loadmore_any/flutter_loadmore_any.dart';

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
