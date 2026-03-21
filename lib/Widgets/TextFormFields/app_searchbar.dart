import 'package:family_app/Helpers/app_colors.dart';
import 'package:flutter/material.dart';

class AppSearchbar extends StatefulWidget {
  const AppSearchbar({
    super.key,
    required this.controller,
    this.onChange,
  });

  final TextEditingController controller;

  /// Correct type for TextFormField.onChanged
  final ValueChanged<String>? onChange;

  @override
  State<AppSearchbar> createState() => _AppSearchbarState();
}

class _AppSearchbarState extends State<AppSearchbar> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      onChanged: widget.onChange,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: "Search here...",
        hintStyle: Theme.of(context).textTheme.bodyMedium,
        filled: true,
        fillColor: AppColors.grey.withOpacity(0.1),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 12),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}