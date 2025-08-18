// features/terms_search/presentation/widgets/terms_search_input.dart

import 'package:flutter/material.dart';

class TermsSearchInput extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const TermsSearchInput({super.key, required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Que cherchez-vous ? (ex: balade, baignade…) ',
        prefixIcon: Icon(Icons.search),
      ),
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
    );
  }
}
