import 'package:flutter/material.dart';

class RealTextField extends StatelessWidget {
  //final String label;
  final TextEditingController controller;
  final bool isObscure;
  final VoidCallback? onToggleVisibility;
  final bool showSuffixIcon;
  final String? errorText;

  const RealTextField({
    super.key,
    // required this.label,
    required this.controller,
    this.isObscure = false,
    this.onToggleVisibility,
    this.showSuffixIcon = false,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        errorText: errorText,
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: errorText == null ? Colors.grey : Colors.red,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),

        suffixIcon:
            showSuffixIcon
                ? IconButton(
                  icon: Icon(
                    isObscure ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: onToggleVisibility,
                )
                : null,
      ),
    );
  }
}
