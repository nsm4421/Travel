part of 'page.dart';

class IconsWidget extends StatelessWidget {
  const IconsWidget(this._feed, {super.key});

  final FeedEntity _feed;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      /// 좋아요 버튼
      BlocBuilder<LikeCubit<FeedEntity>, LikeState>(builder: (context, state) {
        return Padding(
            padding: const EdgeInsets.only(left: 6),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(
                  icon: state.isLike
                      ? Icon(Icons.favorite,
                          color: Theme.of(context).colorScheme.primary)
                      : Icon(Icons.favorite_border,
                          color: Theme.of(context).colorScheme.tertiary),
                  onPressed: () {
                    if (!state.status.ok) {
                      return;
                    } else if (state.isLike) {
                      context.read<LikeCubit<FeedEntity>>().cancelLike();
                    } else {
                      context.read<LikeCubit<FeedEntity>>().sendLike();
                    }
                  }),
              Text('${state.likeCount}',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: state.isLike
                          ? Theme.of(context).colorScheme.primary
                          : null))
            ]));
      }),

      /// 댓글 버튼
      Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(
                icon: const Icon(Icons.comment_outlined),
                onPressed: () async {
                  // nav바 감추기
                  context.read<HomeBottomNavCubit>().handleVisible(false);
                  // 댓글창 띄우기
                  await showModalBottomSheet<void>(
                      context: context,
                      showDragHandle: true,
                      isScrollControlled: true,
                      builder: (context) => FeedCommentPage(_feed)).then((_) {
                    // nav바 띄우기
                    context.read<HomeBottomNavCubit>().handleVisible(true);
                  });
                }),
            Text('${_feed.commentCount}',
                style: Theme.of(context).textTheme.labelLarge)
          ])),

      /// TODO : DM버튼
      Padding(
          padding: const EdgeInsets.only(left: 8),
          child: IconButton(
              icon: const Icon(Icons.send_outlined), onPressed: () {}))
    ]);
  }
}