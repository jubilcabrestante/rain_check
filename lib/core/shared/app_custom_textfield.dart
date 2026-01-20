import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rain_check/app/themes/colors.dart';

class AppTextFormField extends StatelessWidget {
  final FocusNode? focusNode;
  final bool? isPassword;
  final bool? isShowPassword;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Function(bool)? onPressed;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String hintText;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;
  const AppTextFormField({
    super.key,
    this.focusNode,
    this.controller,
    this.validator,
    required this.hintText,
    this.isPassword = false,
    this.isShowPassword,
    this.onPressed,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).textTheme;
    var style = theme.bodyMedium;
    return TextFormField(
      focusNode: focusNode,
      onChanged: onChanged,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      obscureText: isPassword! ? isShowPassword! : false,
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        label: Text(hintText, style: theme.bodyMedium),
        hintText: hintText,
        suffixIcon: isPassword!
            ? IconButton(
                onPressed: () {
                  isShowPassword != !isShowPassword!;
                  bool value = !isShowPassword!;
                  onPressed?.call(value);
                },
                icon: Icon(
                  isShowPassword! ? Icons.visibility : Icons.visibility_off,
                ),
              )
            : null,
      ),
      style: style,
      cursorColor: AppColors.primary,
      validator: validator,
      inputFormatters: inputFormatters,
    );
  }
}
