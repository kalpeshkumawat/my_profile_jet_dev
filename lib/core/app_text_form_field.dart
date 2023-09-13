import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final Widget? perfixicon;
  final TextInputType textInputType;
  final Widget? suifxicon;
  final String? labletext;
  final Color? color;
  final Function? validate;
  final Function? onChange;
  final bool? obscuretext;
  final bool? enable;
  final String? hinttext;
  final TextStyle? hintstyle;

  const AppTextFormField({
    super.key,
    required this.controller,
    this.textInputAction,
    this.focusNode,
    this.nextFocusNode,
    this.perfixicon,
    required this.textInputType,
    this.suifxicon,
    required this.labletext,
    this.obscuretext,
    this.color,
    this.validate,
    this.enable,
    this.hinttext,
    this.hintstyle,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: textInputAction,
      keyboardType: textInputType,
      controller: controller,
      onFieldSubmitted: (String value) {
        FocusScope.of(context).requestFocus(nextFocusNode);
      },
      style:  const TextStyle(
              decoration: TextDecoration.none,
              fontSize: 16.0,
              fontWeight: FontWeight.normal,
              color: Colors.black87),
      onChanged: (value) {
        if (onChange != null) {
          onChange!(value);
        }
      },
      validator: (value) {
        return validate != null ? validate!(value) : null;
      },
      focusNode: focusNode,
      obscureText: obscuretext ?? false,
      decoration: InputDecoration(
        prefixIcon: perfixicon,
        suffixIcon: suifxicon,
        filled: true,
        border: const OutlineInputBorder(),
        fillColor: color,
        labelText: labletext,
        labelStyle: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.normal,

        ),
        hintText: hinttext,
        enabled: enable ?? true,

        disabledBorder: const OutlineInputBorder(),
      ),
    );
  }
}
