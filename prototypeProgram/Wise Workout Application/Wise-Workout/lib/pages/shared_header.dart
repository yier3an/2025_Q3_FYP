
import 'package:flutter/material.dart';

class SharedHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onNotifications;
  final VoidCallback? onSettings;
  const SharedHeader({super.key, this.onNotifications, this.onSettings});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leadingWidth: 56,
      leading: const Padding(
        padding: EdgeInsets.only(left: 8.0),
        child: CircleAvatar(child: Icon(Icons.person)),
      ),
      title: const Text('WISE WORKOUT'),
      actions: [
        IconButton(onPressed: onNotifications, icon: const Icon(Icons.notifications_none)),
        IconButton(onPressed: onSettings, icon: const Icon(Icons.settings_outlined)),
      ],
    );
  }
}
