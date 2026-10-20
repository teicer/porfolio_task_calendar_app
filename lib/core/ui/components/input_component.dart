import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:porfolio_task_calendar_app/core/app/app_numbers.dart';
import 'package:porfolio_task_calendar_app/core/utils/extension/context_extension.dart';

class InputComponent extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final bool isNumberOnly;
  final bool isPositiveInt;
  final bool isPassword;
  final String hint;
  final FocusNode? node;
  final bool isEnabled;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final VoidCallback? onClick;
  final bool description;
  final bool onCard;
  final bool topPadding;
  final bool isEmail;

  const InputComponent({
    super.key,
    required this.title,
    required this.controller,
    this.isNumberOnly = false,
    this.isPositiveInt = false,
    this.hint = '',
    this.node,
    this.isEnabled = true,
    this.onChanged,
    this.readOnly = false,
    this.onClick,
    this.description = false,
    this.topPadding = true,
    this.onCard = false,
    this.isPassword = false,
    this.isEmail = false,
  });

  @override
  State<InputComponent> createState() => _InputComponentState();
}

class _InputComponentState extends State<InputComponent> {
  late bool _obscureText;
  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.topPadding ? const EdgeInsets.only(top: AppNumbers.space) : EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.title.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(left: AppNumbers.space),
              child: Text(
                widget.title,
                style: TextStyle(
                  color: context.color.primaryText,
                  fontWeight: FontWeight.bold,
                  fontSize: AppNumbers.body(context),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: AppNumbers.spaceSmall),
          ],
          TextField(
            onTap: widget.onClick,
            readOnly: widget.readOnly,
            minLines: widget.description ? 3 : 1,
            maxLines: widget.description ? 5 : 1,
            controller: widget.controller,
            focusNode: widget.node,
            keyboardType: widget.isPassword
                ? TextInputType.visiblePassword
                : widget.isNumberOnly
                ? TextInputType.number
                : widget.isEmail
                ? TextInputType.emailAddress
                : TextInputType.text,
            autocorrect: !widget.isEmail && !widget.isPassword,
            obscureText: widget.isPassword ? _obscureText : false,
            inputFormatters: [
              if (widget.isPositiveInt) FilteringTextInputFormatter.digitsOnly,
              if (widget.isNumberOnly && !widget.isPositiveInt) LeadingDotFormatter(),
            ],
            enabled: widget.isEnabled,
            onChanged: widget.onChanged,
            style: TextStyle(color: context.color.primaryText, fontSize: AppNumbers.body(context)),
            decoration: InputDecoration(
              isDense: true,
              hintText: widget.hint,
              hintStyle: TextStyle(color: context.color.secondaryText.withValues(alpha: 0.7)),
              filled: true,
              fillColor: widget.onCard ? context.color.bg : context.color.overBg,

              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: context.color.secondaryText,
                        size: AppNumbers.iconMd(context),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppNumbers.radius),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppNumbers.radius),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppNumbers.radius),
                borderSide: BorderSide(color: context.color.primaryAccent, width: 1.5),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppNumbers.radius),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: AppNumbers.padding, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class LeadingDotFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;

    // If the text is empty, return the new value as is
    if (text.isEmpty) return newValue;

    // If the text is just a minus sign, return the new value as is
    final int minusCount = '-'.allMatches(text).length;
    if (minusCount > 1 || (text.contains('-') && !text.startsWith('-'))) {
      return oldValue;
    }

    // Special case: If the user types just "-" or "-." or "-,"
    if (text == '-') return newValue;
    if (text == '-.' || text == '-,') {
      return const TextEditingValue(text: '-0.', selection: TextSelection.collapsed(offset: 3));
    }

    // Special case: If the user types just "." or ","
    if (text.startsWith('.') || text.startsWith(',')) {
      text = text.replaceAll(',', '.');
      text = '0$text';
      return TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: newValue.selection.baseOffset + 1),
      );
    }

    // Replace any commas with dots for decimal representation
    text = text.replaceAll(',', '.');

    // Ensure that there is at most one dot in the text
    final int dotCount = '.'.allMatches(text).length;
    if (dotCount > 1) {
      return oldValue;
    }

    // If the text starts with a dot, prepend a '0' to it
    if (text != newValue.text) {
      return TextEditingValue(text: text, selection: newValue.selection);
    }

    return newValue;
  }
}
