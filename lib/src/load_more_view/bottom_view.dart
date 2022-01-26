import 'package:flutter/material.dart';

import 'load_more_view.dart';

class BottomViewNotification extends Notification {}

class BottomView extends StatelessWidget {
  final LoadMoreStatus status;

  final Widget? loadView;
  final Widget? emptyView;
  final Widget? errorView;
  final Widget? completeView;
  final String? loadingText;
  final String? errorText;
  final String? emptyText;
  final String? completeText;
  final double height;

  BottomView(
      {Key? key,
      required this.status,
      required this.height,
      this.loadView,
      this.emptyView,
      this.errorView,
      this.loadingText,
      this.errorText,
      this.emptyText,
      this.completeView,
      this.completeText})
      : super(key: key);
  late final BottomViewNotification _notification = BottomViewNotification();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (status == LoadMoreStatus.idle) {
        _notification.dispatch(context);
      }
    });
    return status == LoadMoreStatus.idle
        ? SizedBox(height: height,)
        : SizedBox(
            child: Center(
              child: (status == LoadMoreStatus.empty
                  ? emptyView ?? Text(emptyText ?? '人家也是有底线的~~')
                  : (status == LoadMoreStatus.fail
                      ? GestureDetector(
                          child: errorView ?? Text(errorText ?? '加载失败，点击重试'),
                          onTap: () {
                            _notification.dispatch(context);
                          },
                        )
                      : (status == LoadMoreStatus.complete
                          ? GestureDetector(
                              child:
                                  errorView ?? Text(errorText ?? '加载成功，点击加载更多'),
                              onTap: () {
                                _notification.dispatch(context);
                              },
                            )
                          : _buildLoadMoreView(context)))),
            ),
            height: height,
          );
  }

  _buildLoadMoreView(BuildContext context) {
    return loadView ??
        SizedBox(
          height: height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(loadingText ?? '加载中...')
            ],
          ),
        );
  }
}
