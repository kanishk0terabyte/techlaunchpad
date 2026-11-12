import 'package:flutter/material.dart';

enum CardLayout { vertical, horizontal }

class CustomCard extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String? subtitle;
  final List<String>? tags;
  final String? actionLabel;
  final VoidCallback? onActionTap;
  final VoidCallback? onTap;
  final CardLayout layout;
  final Widget? leading;
  final Widget? trailing;
  final double? imageHeight;
  final EdgeInsets? padding;

  const CustomCard({
    super.key,
    this.imageUrl,
    required this.title,
    this.subtitle,
    this.tags,
    this.actionLabel,
    this.onActionTap,
    this.onTap,
    this.layout = CardLayout.vertical,
    this.leading,
    this.trailing,
    this.imageHeight,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      shadowColor: theme.colorScheme.shadow.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: layout == CardLayout.vertical ? _buildVertical(theme) : _buildHorizontal(theme),
      ),
    );
  }

  Widget _buildVertical(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (imageUrl != null) _buildImage(height: imageHeight ?? 160, width: double.infinity),
        Padding(
          padding: padding ?? const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (leading != null) ...[leading!, const SizedBox(height: 8)],
              Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(subtitle!, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant), maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
              if (tags != null && tags!.isNotEmpty) ...[
                const SizedBox(height: 10),
                _buildTags(theme),
              ],
              if (actionLabel != null) ...[
                const SizedBox(height: 12),
                _buildActionButton(theme),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontal(ThemeData theme) {
    return SizedBox(
      height: 120,
      child: Row(
        children: [
          if (imageUrl != null) _buildImage(width: 120, height: 120),
          Expanded(
            child: Padding(
              padding: padding ?? const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (leading != null) ...[leading!, const SizedBox(height: 4)],
                  Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(subtitle!, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant), maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                  if (tags != null && tags!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _buildTags(theme),
                  ],
                ],
              ),
            ),
          ),
          if (trailing != null) Padding(padding: const EdgeInsets.only(right: 12), child: trailing!),
        ],
      ),
    );
  }

  Widget _buildImage({double? width, double? height}) {
    return SizedBox(
      width: width,
      height: height,
      child: Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          color: Colors.grey.shade200,
          child: const Icon(Icons.image_not_supported_outlined, size: 40, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildTags(ThemeData theme) {
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: tags!.take(3).map((tag) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(tag, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w500)),
      )).toList(),
    );
  }

  Widget _buildActionButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onActionTap,
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(actionLabel!),
      ),
    );
  }
}
