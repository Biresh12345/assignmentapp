import 'package:flutter/material.dart';

class InputBox extends StatelessWidget {
  final String titleName;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool readOnly;
  final TextEditingController? controller;

  const InputBox({
    super.key,
    required this.controller,
    required this.titleName,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
          enabledBorder: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(),
          hintText: titleName,
          hintStyle: Theme.of(context).textTheme.titleSmall,
        ),
      ),
    );
  }
}
