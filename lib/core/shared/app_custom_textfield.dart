import 'package:flutter/material.dart';

class AppCustomTextfield extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final String label;
  final bool? isPassword;
  final EdgeInsetsGeometry? padding;
  final String? type;
  final int? maxLines;
  final String? Function(String?)? validator;

  const AppCustomTextfield({
    super.key,
    this.type,
    required this.controller,
    this.isPassword = false,
    this.hintText,
    required this.label,
    this.padding,
    this.maxLines,
    this.validator,
  });

  @override
  State<AppCustomTextfield> createState() => _AppCustomTextfieldState();
}

class _AppCustomTextfieldState extends State<AppCustomTextfield> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.isPassword == true ? _obscureText : false,
        validator: widget.validator,
        keyboardType: _getKeyboardType(widget.type),
        maxLines: widget.isPassword == true ? 1 : widget.maxLines,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          suffixIcon: widget.isPassword == true
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }

  TextInputType _getKeyboardType(String? type) {
    switch (type) {
      case 'number':
        return TextInputType.number;
      case 'email':
        return TextInputType.emailAddress;
      case 'phone':
        return TextInputType.phone;
      default:
        return TextInputType.text;
    }
  }
}
