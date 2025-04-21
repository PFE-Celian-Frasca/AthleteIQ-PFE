import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final IconData? backIcon;
  final bool hasBackButton;
  final List<Widget>? actions;
  final VoidCallback? onBackButtonPressed;

  const CustomAppBar({
    super.key,
    this.title,
    this.backIcon,
    this.hasBackButton = false,
    this.actions,
    this.onBackButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title != null ? Text(
        title!,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ) : null,
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.background,
      leading: hasBackButton ? IconButton(
        icon: Icon(backIcon ?? Icons.arrow_back, color: Theme.of(context).colorScheme.onBackground),
        onPressed: onBackButtonPressed,
      ) : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
