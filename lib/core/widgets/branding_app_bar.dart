import 'package:flutter/material.dart';

class BrandingAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const BrandingAppBar({
    super.key,
    this.title = 'Polias e Correias',
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(title: Text(title), actions: actions);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
