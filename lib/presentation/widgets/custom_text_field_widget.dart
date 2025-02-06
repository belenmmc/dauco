import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final bool enabled;
  final Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.labelText,
    this.validator,
    this.controller,
    this.keyboardType = TextInputType.text,
    required this.icon,
    this.obscureText = false,
    this.suffixIcon,
    this.onTap,
    this.enabled = true,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      obscureText: obscureText,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black87,
        fontWeight: FontWeight.w500,
      ),
      onTap: onTap,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          fontSize: 14,
          color: Color(0xFFA4A4A4),
          fontWeight: FontWeight.w400,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide.none,
        ),
        suffixIcon: suffixIcon ?? Icon(icon, color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 12.0,
        ),
        fillColor: const Color.fromARGB(255, 255, 255, 255),
        filled: true,
      ),
    );
  }
}
