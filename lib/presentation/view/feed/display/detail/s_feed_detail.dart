part of '../page.dart';

class FeedDetailScreen extends StatefulWidget {
  const FeedDetailScreen(this._feed, {super.key});

  final FeedEntity _feed;

  @override
  State<FeedDetailScreen> createState() => _FeedDetailScreenState();
}

class _FeedDetailScreenState extends State<FeedDetailScreen> {
  late ScrollController _scrollController;
  bool _showJumpUp = false;

  @override
  initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_handleOnMoveScroll);
  }

  @override
  dispose() {
    super.dispose();
    _scrollController
      ..removeListener(_handleOnMoveScroll)
      ..dispose();
  }

  _handlePop() {
    if (context.mounted) {
      context.pop();
    }
  }

  _handleOnMoveScroll() {
    setState(() {
      _showJumpUp = _scrollController.offset > 30;
    });
  }

  _handleJumpToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// 작성자 정보
      appBar: AppBar(
          elevation: 0,
          leading: widget._feed.author?.avatarUrl == null
              ? null
              : CircularAvatarWidget(widget._feed.author!.avatarUrl),
          title: Text(widget._feed.author?.username ?? ''),
          actions: [
            IconButton(icon: const Icon(Icons.clear), onPressed: _handlePop)
          ]),

      /// 본문
      body: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 해시태그
              if (widget._feed.hashtags.isNotEmpty)
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SizedBox(height: 8),
                  DisplayHashtagsWidget(widget._feed.hashtags),
                  const SizedBox(height: 8),
                  const Divider()
                ]),

              // 이미지, 캡션
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget._feed.length,
                itemBuilder: (context, index) {
                  final image = widget._feed.images?[index];
                  final caption = widget._feed.captions?[index] ?? '';
                  return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (image != null)
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.fitHeight,
                                          image: CachedNetworkImageProvider(
                                              image)))),
                            if (caption.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 12),
                                child: Text(caption,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontWeight: FontWeight.w700)),
                              )
                          ]));
                },
                separatorBuilder: (context, index) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(indent: 20, endIndent: 20, thickness: 1),
                  );
                },
              ),
            ],
          )),

      // 맨 위로 버튼
      floatingActionButton: _showJumpUp
          ? FloatingActionButton(
              shape: const CircleBorder(),
              onPressed: _handleJumpToTop,
              child: const Icon(Icons.arrow_upward))
          : null,
    );
  }
}