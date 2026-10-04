import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/colors.dart';

/// A row of single-digit boxes backed by ONE real text field, not one real
/// field per box. The real field is fully invisible and sized to cover the
/// whole row; tapping anywhere focuses it, and what's actually drawn in
/// each box is just a character read from [controller]'s current text.
///
/// This is the same approach mature OTP-input packages use internally (a
/// single underlying TextEditingController, boxes as pure visual output) —
/// built directly here instead of depending on one of those packages after
/// hitting, in order: a package with a genuinely broken multi-field
/// implementation (invisible text, a callback that silently dropped all but
/// the latest keystroke, a maxLength bug that let one box's input spill
/// into every other box), and then a second, better-architected package
/// whose current release requires the separate `material_ui` package that
/// this app's `flutter/material.dart`-based Scaffold/theme don't satisfy.
/// Since there's only ever one real field, auto-advance and
/// backspace-to-previous aren't separate behaviors to implement — they're
/// just what typing into and deleting from a normal text field already does.
class DigitBoxesField extends StatefulWidget {
  const DigitBoxesField({
    super.key,
    required this.length,
    required this.controller,
    required this.onChanged,
    this.onCompleted,
    this.boxWidth = 32,
    this.boxHeight = 48,
    this.spacing = 6,
    this.fontSize = 20,
    this.autofocus = false,
  });

  final int length;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onCompleted;
  final double boxWidth;
  final double boxHeight;
  final double spacing;
  final double fontSize;
  final bool autofocus;

  @override
  State<DigitBoxesField> createState() => _DigitBoxesFieldState();
}

class _DigitBoxesFieldState extends State<DigitBoxesField> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Only the focused box's underline needs to change on a pure focus
    // change (no text change), which ValueListenableBuilder on the
    // controller alone wouldn't catch.
    _focusNode.addListener(_onFocusChanged);
  }

  void _onFocusChanged() => setState(() {});

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    super.dispose();
  }

  double get _totalWidth =>
      widget.length * widget.boxWidth + (widget.length - 1) * widget.spacing;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _focusNode.requestFocus(),
      child: SizedBox(
        width: _totalWidth,
        height: widget.boxHeight,
        child: Stack(
          children: [
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: widget.controller,
              builder: (context, value, _) {
                final nextIndex = value.text.length.clamp(0, widget.length - 1);
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 0; i < widget.length; i++) ...[
                      if (i > 0) SizedBox(width: widget.spacing),
                      Container(
                        width: widget.boxWidth,
                        height: widget.boxHeight,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: (_focusNode.hasFocus && i == nextIndex)
                                  ? aAccentColor
                                  : aPrimaryColor,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Text(
                          i < value.text.length ? value.text[i] : '',
                          style: TextStyle(
                            color: aPrimaryColor,
                            fontSize: widget.fontSize,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
            // The real field: invisible, no cursor/selection UI of its own
            // (the boxes above are the only thing the user sees), existing
            // purely to own the TextEditingController and receive IME input.
            Opacity(
              opacity: 0,
              child: TextField(
                controller: widget.controller,
                focusNode: _focusNode,
                autofocus: widget.autofocus,
                keyboardType: TextInputType.number,
                maxLength: widget.length,
                showCursor: false,
                enableInteractiveSelection: false,
                decoration: const InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(widget.length),
                ],
                onChanged: (value) {
                  widget.onChanged(value);
                  if (value.length == widget.length) {
                    widget.onCompleted?.call(value);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
