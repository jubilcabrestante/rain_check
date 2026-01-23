import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppCustomTextField extends StatefulWidget {
  final bool isPassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String hintText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;

  const AppCustomTextField({
    super.key,
    this.controller,
    this.validator,
    required this.hintText,
    this.isPassword = false,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.onChanged,
  });

  @override
  State<AppCustomTextField> createState() => _AppCustomTextFieldState();
}

class _AppCustomTextFieldState extends State<AppCustomTextField> {
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      onChanged: widget.onChanged,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      obscureText: widget.isPassword && !_showPassword,
      decoration: InputDecoration(
        hintText: widget.hintText,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _showPassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _showPassword = !_showPassword;
                  });
                },
              )
            : null,
      ),
    );
  }
}
