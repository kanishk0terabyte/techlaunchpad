import 'package:flutter/material.dart';

class ShimmerLoading extends StatefulWidget {
  final int itemCount;
  final bool isGrid;
  final int gridCrossAxisCount;
  final double? itemHeight;

  const ShimmerLoading({
    super.key,
    this.itemCount = 5,
    this.isGrid = false,
    this.gridCrossAxisCount = 2,
    this.itemHeight,
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat();
    _animation = Tween<double>(begin: -2, end: 2).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isGrid) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.gridCrossAxisCount,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemCount: widget.itemCount,
        itemBuilder: (_, __) => _ShimmerCard(animation: _animation, isGrid: true),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: widget.itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => _ShimmerCard(animation: _animation, height: widget.itemHeight),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  final Animation<double> animation;
  final bool isGrid;
  final double? height;

  const _ShimmerCard({required this.animation, this.isGrid = false, this.height});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey.shade800 : Colors.grey.shade200;
    final highlightColor = isDark ? Colors.grey.shade700 : Colors.grey.shade100;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          height: isGrid ? null : (height ?? 110),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [baseColor, highlightColor, baseColor],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(animation.value, 0),
              end: Alignment(animation.value + 2, 0),
            ),
          ),
          child: isGrid ? _gridContent(baseColor, highlightColor) : _listContent(baseColor, highlightColor),
        );
      },
    );
  }

  Widget _gridContent(Color base, Color highlight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: Container(decoration: BoxDecoration(color: base, borderRadius: const BorderRadius.vertical(top: Radius.circular(16))))),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerBox(base, double.infinity, 12),
                const SizedBox(height: 8),
                _shimmerBox(base, 80, 10),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _listContent(Color base, Color highlight) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(width: 80, height: 80, decoration: BoxDecoration(color: base, borderRadius: BorderRadius.circular(12))),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _shimmerBox(base, double.infinity, 14),
                const SizedBox(height: 10),
                _shimmerBox(base, 140, 10),
                const SizedBox(height: 10),
                _shimmerBox(base, 80, 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _shimmerBox(Color color, double width, double height) {
    return Container(width: width, height: height, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)));
  }
}

class AnimatedBuilder extends AnimatedWidget {
  final Widget Function(BuildContext, Widget?) builder;
  const AnimatedBuilder({super.key, required super.listenable, required this.builder});
  Animation<double> get animation => listenable as Animation<double>;
  @override
  Widget build(BuildContext context) => builder(context, null);
}

class LoadingIndicator extends StatelessWidget {
  final String? message;
  const LoadingIndicator({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: theme.colorScheme.primary, strokeWidth: 3),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(message!, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ],
        ],
      ),
    );
  }
}
