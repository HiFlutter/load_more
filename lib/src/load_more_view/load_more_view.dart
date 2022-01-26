import 'package:flutter/material.dart';

import 'dart:math';

import 'bottom_view.dart';

enum LoadMoreStatus {
  /// 空闲中，表示当前等待加载
  idle,

  /// 刷新中，不应该继续加载
  loading,

  /// 刷新失败，刷新失败，这时需要点击才能刷新
  fail,

  ///加载完成
  complete,

  /// 没有更多，没有更多数据了，
  empty
}

typedef LoadMoreCallback = Future<void> Function();

class LoadMoreView extends StatefulWidget {
  /// 组件必须是sliver可以参考[SliverList]或者[SliverGrid]
  final List<Widget> slivers;

  ///正在加载 加载组件
  final Widget? loadView;

  ///加载完成空数据组件
  final Widget? emptyView;

  ///完成加载widget
  final Widget? completeView;

  ///加载完成错误组件
  final Widget? errorView;

  ///正在加载时 加载提示
  final String? loadingText;

  ///加载错误时 错误提示
  final String? errorText;

  ///完成加载文字
  final String? completeText;

  ///加载没有数据时 空提示
  final String? emptyText;

  ///上拉加载回调
  final LoadMoreCallback onLoadMore;

  ///加载是否没有数据
  final bool isEmpty;

  ///加载是否出现错误
  final bool isError;

  ///底部加载组件高度 默认30
  final double? height;

  ///偏移量 滚动到距离底部还有[scrollOffset]触发上拉加载 默认100
  final double? scrollOffset;

  ///不满一屏是否开启上拉加载
  final bool? disableLoadMoreIfNotFullPage;

  ///上拉加载延迟 最小100毫秒
  final int? duration;

  const LoadMoreView(
      {Key? key,
      required this.onLoadMore,
      required this.isEmpty,
      required this.isError,
      required this.slivers,
      this.completeView,
      this.completeText,
      this.loadView,
      this.emptyView,
      this.errorView,
      this.height = 30,
      this.loadingText,
      this.errorText,
      this.emptyText,
      this.disableLoadMoreIfNotFullPage = false,
      this.duration = 0,
      this.scrollOffset = 100})
      : super(key: key);

  @override
  _LoadMoreViewState createState() => _LoadMoreViewState();
}

class _LoadMoreViewState extends State<LoadMoreView> {
  LoadMoreStatus _status = LoadMoreStatus.idle;
  bool fullPage = false;

  late final GlobalKey _key = GlobalKey();
  late final GlobalKey _key1 = GlobalKey();

  @override
  void didUpdateWidget(covariant LoadMoreView oldWidget) {
    if (_status == LoadMoreStatus.empty && !widget.isEmpty && !widget.isError) {
      _updateStatus(LoadMoreStatus.idle);
    }
    if (widget.isEmpty) {
      _updateStatus(LoadMoreStatus.empty);
    }
    if (widget.isError) {
      _updateStatus(LoadMoreStatus.fail);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      var height = _key.currentContext?.size?.height ?? 0;
      var dy = (_key1.currentContext?.findRenderObject() as RenderBox)
          .localToGlobal(Offset.zero)
          .dy;
      fullPage = dy >= height;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      child: _buildChild(),
      onNotification: (_) => _onNotification(_, context),
    );
  }

  List<Widget> get slivers => widget.slivers;

  Widget _buildBottom(LoadMoreStatus status) => SliverToBoxAdapter(
          child: NotificationListener<BottomViewNotification>(
        child: BottomView(
          key: _key1,
          height: widget.height!,
          status: _status,
          errorText: widget.errorText,
          errorView: widget.errorView,
          loadingText: widget.loadingText,
          loadView: widget.loadView,
          emptyText: widget.emptyText,
          emptyView: widget.emptyView,
          completeView: widget.completeView,
          completeText: widget.completeText,
        ),
        onNotification: (_) => _onBottomNotification(_, context),
      ));

  List<Widget> get realSlivers {
    if (slivers[slivers.length - 1].runtimeType == SliverToBoxAdapter) {
      slivers.removeLast();
    }
    slivers.add(_buildBottom(_status));
    return slivers;
  }

  _buildChild() {
    return CustomScrollView(key: _key, slivers: realSlivers);
  }

  bool _onBottomNotification(
      BottomViewNotification notification, BuildContext context) {
    if ((widget.disableLoadMoreIfNotFullPage!) && !fullPage) {
      loadMore();
    }
    return false;
  }

  bool _onNotification(ScrollNotification notification, BuildContext context) {
    //当前滚动距离
    double currentExtent = notification.metrics.pixels;
    //最大滚动距离
    double maxExtent = notification.metrics.maxScrollExtent;

    //开始滚动
    if (notification is ScrollStartNotification) {
      if ((_status == LoadMoreStatus.idle)) {
        _updateStatus(LoadMoreStatus.complete);
      }
    }

    //滚动更新过程中，并且设置非滚动到底部可以触发加载更多
    if ((notification is ScrollUpdateNotification)) {
      if ((_status == LoadMoreStatus.idle)) {
        _updateStatus(LoadMoreStatus.complete);
      }

      if (maxExtent - currentExtent <= max<double>(100, widget.scrollOffset!)) {
        if (_status == LoadMoreStatus.idle ||
            _status == LoadMoreStatus.complete) {
          loadMore();
          return true;
        }
      }
    }

    //滚动到底部，并且设置滚动到底部才触发加载更多
    if ((notification is ScrollEndNotification)) {
      //滚动到底部并且加载状态为正常时，调用加载更多
      if (currentExtent >= maxExtent) {
        if (_status == LoadMoreStatus.idle ||
            _status == LoadMoreStatus.complete) {
          loadMore();
          return true;
        }
      }
    }

    return false;
  }

  _updateStatus(LoadMoreStatus status) {
    if (mounted && _status != status) {
      setState(() {
        _status = status;
      });
    }
  }

  loadMore() {
    _updateStatus(LoadMoreStatus.loading);
    Future.delayed(Duration(milliseconds: max<int>(100, widget.duration!)))
        .whenComplete(() => widget
            .onLoadMore()
            .whenComplete(() => _status = LoadMoreStatus.complete));
  }
}
