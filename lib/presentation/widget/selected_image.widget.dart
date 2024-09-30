part of 'widgets.dart';

class SelectedImageWidget extends StatefulWidget {
  const SelectedImageWidget(
      {super.key,
      required this.imageWidth,
      required this.imageHeight,
      required this.selectedImage,
      required this.selectedIndex,
      required this.blocks});

  final double imageWidth;
  final double imageHeight;
  final SelectedImage selectedImage;
  final int selectedIndex;
  final List<Block> blocks;

  @override
  State<SelectedImageWidget> createState() => _SelectedImageWidgetState();
}

class _SelectedImageWidgetState extends State<SelectedImageWidget> {
  late List<Block> _adjustedBlocks;

  @override
  void initState() {
    super.initState();
    double widthRatio = widget.imageWidth / widget.selectedImage.width;
    double heightRatio = widget.imageHeight / widget.selectedImage.height;
    _adjustedBlocks = widget.blocks
        .map((item) => Block(
            left: item.left * widthRatio,
            top: item.top * heightRatio,
            width: item.width * widthRatio,
            height: item.height * heightRatio,
            originalText: item.originalText))
        .toList();
  }

  _handleSelectBlock(int index) => () {
        if (context.read<ImageToTextBloc>().state.status.ok) {
          log('[SelectedImageWidget][_handleSelectBlock]function called');
          context.read<ImageToTextBloc>().add(ChangeSelectedBoxEvent(index));
        }
      };

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            width: widget.imageWidth,
            height: widget.imageHeight,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: FileImage(widget.selectedImage.image)))),
        ...List.generate(_adjustedBlocks.length, (index) {
          final block = _adjustedBlocks[index];
          return Positioned(
            left: block.left,
            top: block.top,
            child: GestureDetector(
              onTap: _handleSelectBlock(index),
              child: CustomPaint(
                size: Size(block.width, block.height), // Rectangle size
                painter:
                    OutlineHighlight(isSelected: widget.selectedIndex == index),
              ),
            ),
          );
        })
      ],
    );
  }
}
