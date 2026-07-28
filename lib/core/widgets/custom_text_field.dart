import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final bool obscureText;
  final bool readOnly;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final void Function(String)? onChanged;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final VoidCallback? onEditingComplete;
  final bool enableRealTimeValidation;

  const CustomTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.obscureText = false,
    this.readOnly = false,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.focusNode,
    this.textInputAction,
    this.onEditingComplete,
    this.enableRealTimeValidation = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  String? _errorText;
  bool _hasInteracted = false;

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    if (widget.enableRealTimeValidation && _hasInteracted) {
      _validate(widget.controller?.text);
    }
  }

  void _validate(String? value) {
    if (widget.validator != null) {
      setState(() {
        _errorText = widget.validator!(value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: widget.controller,
          obscureText: widget.obscureText,
          readOnly: widget.readOnly,
          maxLines: widget.maxLines,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          onSaved: widget.onSaved,
          onChanged: (value) {
            if (!_hasInteracted) {
              _hasInteracted = true;
            }
            if (widget.enableRealTimeValidation) {
              _validate(value);
            }
            widget.onChanged?.call(value);
          },
          focusNode: widget.focusNode,
          textInputAction: widget.textInputAction,
          onEditingComplete: widget.onEditingComplete,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            labelText: widget.labelText,
            hintText: widget.hintText,
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon, color: AppColors.grey500, size: 20)
                : null,
            suffixIcon: _buildSuffixIcon(),
            errorText: widget.enableRealTimeValidation ? _errorText : null,
            errorStyle: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.enableRealTimeValidation && _hasInteracted) {
      if (_errorText == null && widget.controller?.text.isNotEmpty == true) {
        return const Icon(Icons.check_circle, color: AppColors.success, size: 20);
      } else if (_errorText != null) {
        return const Icon(Icons.error, color: AppColors.error, size: 20);
      }
    }

    if (widget.suffixIcon != null) {
      return GestureDetector(
        onTap: widget.onSuffixTap,
        child: Icon(widget.suffixIcon, color: AppColors.grey500, size: 20),
      );
    }

    return null;
  }
}
