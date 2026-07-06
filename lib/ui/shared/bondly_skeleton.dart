import 'package:flutter/material.dart';

class BondlyShimmerBlock extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const BondlyShimmerBlock({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  State<BondlyShimmerBlock> createState() => _BondlyShimmerBlockState();
}

class _BondlyShimmerBlockState extends State<BondlyShimmerBlock>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.08);
    final shimmerColor = isDark
        ? Colors.white.withValues(alpha: 0.15)
        : Colors.black.withValues(alpha: 0.04);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [baseColor, shimmerColor, baseColor],
              stops: [
                (_animation.value - 0.3).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 0.3).clamp(0.0, 1.0),
              ],
            ),
          ),
        );
      },
    );
  }
}

class BondlyShimmerCircle extends StatefulWidget {
  final double size;

  const BondlyShimmerCircle({super.key, required this.size});

  @override
  State<BondlyShimmerCircle> createState() => _BondlyShimmerCircleState();
}

class _BondlyShimmerCircleState extends State<BondlyShimmerCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.08);
    final shimmerColor = isDark
        ? Colors.white.withValues(alpha: 0.15)
        : Colors.black.withValues(alpha: 0.04);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [baseColor, shimmerColor, baseColor],
              stops: [
                (_animation.value - 0.3).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 0.3).clamp(0.0, 1.0),
              ],
            ),
          ),
        );
      },
    );
  }
}

class LoginSkeletonLoader extends StatelessWidget {
  final double screenWidth;

  const LoginSkeletonLoader({super.key, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.center,
      child: SizedBox(
        width: screenWidth,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo placeholder
                const Center(
                  child: BondlyShimmerBlock(
                    width: 200,
                    height: 160,
                    borderRadius: 20,
                  ),
                ),
                const SizedBox(height: 16),
                // Title placeholder
                const Center(
                  child: BondlyShimmerBlock(width: 220, height: 24),
                ),
                const SizedBox(height: 4),
                // Subtitle placeholder
                const Center(
                  child: BondlyShimmerBlock(width: 200, height: 14),
                ),
                const SizedBox(height: 32),
                // User input field
                const BondlyShimmerBlock(
                  width: double.infinity,
                  height: 52,
                  borderRadius: 16,
                ),
                const SizedBox(height: 14),
                // Password input field
                const BondlyShimmerBlock(
                  width: double.infinity,
                  height: 52,
                  borderRadius: 16,
                ),
                const SizedBox(height: 14),
                // Login button
                const BondlyShimmerBlock(
                  width: double.infinity,
                  height: 52,
                  borderRadius: 16,
                ),
                const SizedBox(height: 14),
                // Forgot password link
                const Center(
                  child: BondlyShimmerBlock(width: 180, height: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ForgotPasswordSkeletonLoader extends StatelessWidget {
  final double screenWidth;

  const ForgotPasswordSkeletonLoader({super.key, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: SizedBox(
        width: screenWidth,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo placeholder
                const Center(
                  child: BondlyShimmerBlock(
                    width: 200,
                    height: 160,
                    borderRadius: 20,
                  ),
                ),
                const SizedBox(height: 16),
                // Title placeholder
                const Center(
                  child: BondlyShimmerBlock(width: 220, height: 24),
                ),
                const SizedBox(height: 12),
                // Description placeholder (2 lines)
                const BondlyShimmerBlock(
                  width: double.infinity,
                  height: 14,
                ),
                const SizedBox(height: 6),
                const Center(
                  child: BondlyShimmerBlock(width: 240, height: 14),
                ),
                const SizedBox(height: 32),
                // Email field
                const BondlyShimmerBlock(
                  width: double.infinity,
                  height: 52,
                  borderRadius: 16,
                ),
                const SizedBox(height: 14),
                // Send button
                const BondlyShimmerBlock(
                  width: double.infinity,
                  height: 52,
                  borderRadius: 16,
                ),
                const SizedBox(height: 14),
                // Back link
                const Center(
                  child: BondlyShimmerBlock(width: 200, height: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
