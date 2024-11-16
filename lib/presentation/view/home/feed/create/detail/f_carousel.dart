part of '../index.dart';

class CarouselFragment extends StatefulWidget {
  const CarouselFragment({super.key});

  @override
  State<CarouselFragment> createState() => _CarouselFragmentState();
}

class _CarouselFragmentState extends State<CarouselFragment> {
  late PageController _controller;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  _handleClickDot(int index) async {
    await _controller.animateToPage(index,
        duration: 200.ms, curve: Curves.easeIn);
  }

  _handlePageChanged(int index) {
    setState(() {
      _currentPage = index + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateFeedBloc, CreateFeedState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                SizedBox(
                  width: context.width,
                  height: context.width,
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: state.images.length,
                    onPageChanged: _handlePageChanged,
                    itemBuilder: (context, index) {
                      final asset = state.images[index];
                      final caption = state.captions[index];
                      return Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetEntityImageProvider(asset),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          if (caption.isNotEmpty)
                            Positioned(
                              bottom: 12,
                              child: Container(
                                alignment: Alignment.center,
                                width: context.width,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                    color: CustomPalette.darkGrey
                                        .withOpacity(0.8)),
                                child: Text(
                                  caption,
                                  softWrap: true,
                                  style: context.textTheme.bodyLarge?.copyWith(
                                    color: CustomPalette.white,
                                    fontWeight: FontWeight.w600,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 6),
                              decoration: BoxDecoration(
                                  color: CustomPalette.darkGrey,
                                  borderRadius: BorderRadius.circular(16)),
                              child: Text(
                                '$_currentPage/${state.images.length}',
                                style: context.textTheme.bodyMedium
                                    ?.copyWith(color: CustomPalette.white),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            if (state.images.length > 1)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Align(
                  alignment: Alignment.center,
                  child: SmoothPageIndicator(
                    controller: _controller,
                    count: state.images.length,
                    onDotClicked: _handleClickDot,
                    effect: SlideEffect(
                        spacing: 8,
                        dotWidth: 12,
                        dotHeight: 13,
                        paintStyle: PaintingStyle.stroke,
                        strokeWidth: 1.5,
                        dotColor: CustomPalette.lightGrey,
                        activeDotColor: context.colorScheme.primary),
                  ),
                ),
              )
          ],
        );
      },
    );
  }
}
