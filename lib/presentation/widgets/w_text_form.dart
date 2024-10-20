part of 'widgets.dart';

class CustomTextFieldWidget extends StatefulWidget {
  const CustomTextFieldWidget(
    this.tec, {
    super.key,
    this.maxLength = 30,
    this.minLine = 1,
    this.maxLine = 1,
    this.showCounterText = true,
    this.prefixIcon,
    this.suffixIcon,
    this.hintText,
    this.helperText,
    this.readOnly = false,
    this.obscureText = false,
    this.isLoading = false,
    this.onTap,
    this.onTapSuffixIcon,
    this.onFocusLeave,
    this.validator,
  });

  final TextEditingController tec;
  final int maxLength;
  final int minLine;
  final int maxLine;
  final bool showCounterText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final String? hintText;
  final String? helperText;
  final bool readOnly;
  final bool obscureText;
  final bool isLoading;
  final void Function()? onTap;
  final void Function()? onTapSuffixIcon;
  final void Function()? onFocusLeave;
  final String? Function(String? text)? validator;

  @override
  State<CustomTextFieldWidget> createState() => _CustomTextFieldWidgetState();
}

class _CustomTextFieldWidgetState extends State<CustomTextFieldWidget> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(_focusNodeListener);
  }

  @override
  void dispose() {
    super.dispose();

    _focusNode
      ..removeListener(_focusNodeListener)
      ..dispose();
  }

  _focusNodeListener() {
    if (widget.onFocusLeave != null && !_focusNode.hasFocus) {
      widget.onFocusLeave!();
    }
  }

  _handleTapSuffixIcon() {
    if (widget.onTapSuffixIcon == null) return;
    widget.onTapSuffixIcon!();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: _focusNode,
      validator: widget.validator,
      controller: widget.tec,
      maxLength: widget.maxLength,
      minLines: widget.minLine,
      maxLines: widget.maxLine,
      obscureText: widget.obscureText,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      decoration: InputDecoration(
          prefixIcon:
              widget.prefixIcon == null ? null : Icon(widget.prefixIcon),
          suffixIcon: (widget.isLoading
              ? Transform.scale(
                  scale: 0.5, child: const CircularProgressIndicator())
              : (widget.suffixIcon == null
                  ? null
                  : IconButton(
                      onPressed: _handleTapSuffixIcon,
                      icon: Icon(widget.suffixIcon)))),
          hintText: widget.hintText,
          counterText: widget.showCounterText ? null : '',
          counterStyle: Theme.of(context)
              .textTheme
              .labelMedium
              ?.copyWith(color: Theme.of(context).colorScheme.tertiary),
          hintStyle: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Theme.of(context).colorScheme.tertiary),
          helperText: widget.helperText,
          helperStyle: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(color: Theme.of(context).colorScheme.tertiary),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
  }
}

class ExpandableTextWidget extends StatefulWidget {
  const ExpandableTextWidget(this.text,
      {super.key, this.minLine = 3, this.textStyle});

  final String text;
  final int minLine;
  final TextStyle? textStyle;

  @override
  State<ExpandableTextWidget> createState() => _ExpandableTextWidgetState();
}

class _ExpandableTextWidgetState extends State<ExpandableTextWidget> {
  bool _isExpanded = false;
  bool _showToggle = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkTextOverflow();
    });
  }

  void _checkTextOverflow() {
    final textSpan = TextSpan(text: widget.text, style: const TextStyle());
    final textPainter = TextPainter(
        text: textSpan,
        maxLines: widget.minLine,
        textDirection: TextDirection.ltr);
    textPainter.layout(maxWidth: MediaQuery.of(context).size.width);
    setState(() {
      _showToggle = textPainter.didExceedMaxLines;
    });
  }

  _handleSwitchExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        widget.text,
        maxLines: _isExpanded ? null : widget.minLine,
        overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
        style: widget.textStyle,
      ),
      const SizedBox(height: 8),
      if (_showToggle)
        GestureDetector(
            onTap: _handleSwitchExpand,
            child: Text(
              _isExpanded ? "Collapse" : "Expand",
              style: const TextStyle(
                  color: Colors.blue, fontWeight: FontWeight.bold),
            ))
    ]);
  }
}
