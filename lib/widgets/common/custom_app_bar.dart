import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final bool showSearch;
  final VoidCallback? onSearchTap;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final bool useGradient;

  const CustomAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.showSearch = false,
    this.onSearchTap,
    this.actions,
    this.leading,
    this.centerTitle = false,
    this.useGradient = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (!useGradient) {
      return AppBar(
        title: _buildTitle(theme),
        centerTitle: centerTitle,
        leading: leading,
        actions: _buildActions(context),
        elevation: 0,
        scrolledUnderElevation: 2,
      );
    }

    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF1A237E), const Color(0xFF0D47A1)]
                : [const Color(0xFF1A73E8), const Color(0xFF1565C0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      title: _buildTitle(theme, isGradient: true),
      centerTitle: centerTitle,
      leading: leading != null
          ? IconTheme(data: const IconThemeData(color: Colors.white), child: leading!)
          : null,
      iconTheme: const IconThemeData(color: Colors.white),
      actions: _buildActions(context),
      elevation: 0,
    );
  }

  Widget _buildTitle(ThemeData theme, {bool isGradient = false}) {
    final color = isGradient ? Colors.white : null;
    if (subtitle == null) {
      return Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: color,
        ),
      );
    }
    return Column(
      crossAxisAlignment: centerTitle ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: color)),
        Text(
          subtitle!,
          style: theme.textTheme.bodySmall?.copyWith(color: color?.withOpacity(0.8) ?? theme.colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return [
      if (showSearch)
        IconButton(
          icon: const Icon(Icons.search_rounded),
          onPressed: onSearchTap,
          tooltip: 'Search',
        ),
      ...?actions,
    ];
  }
}

class GradientAppBarBottom extends StatelessWidget implements PreferredSizeWidget {
  final Widget child;
  final double height;

  const GradientAppBarBottom({super.key, required this.child, this.height = 56});

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) => SizedBox(height: height, child: child);
}
