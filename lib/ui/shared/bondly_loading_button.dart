import 'package:flutter/material.dart';

enum BondlyButtonStyle { filled, outlined, text }

class BondlyLoadingButton extends StatefulWidget {
  final bool isLoading;
  final VoidCallback? onPressed;
  final Widget child;
  final BondlyButtonStyle style;
  final ButtonStyle? buttonStyle;
  final double? width;
  final double? height;

  const BondlyLoadingButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    required this.child,
    this.style = BondlyButtonStyle.filled,
    this.buttonStyle,
    this.width,
    this.height,
  });

  @override
  State<BondlyLoadingButton> createState() => _BondlyLoadingButtonState();
}

class _BondlyLoadingButtonState extends State<BondlyLoadingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(covariant BondlyLoadingButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.isLoading && _controller.isAnimating) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacityAnimation,
      builder: (context, child) {
        final opacity = widget.isLoading ? _opacityAnimation.value : 1.0;
        return Opacity(
          opacity: opacity,
          child: _buildButton(),
        );
      },
    );
  }

  Widget _buildButton() {
    final effectiveOnPressed = widget.isLoading ? null : widget.onPressed;

    switch (widget.style) {
      case BondlyButtonStyle.filled:
        return SizedBox(
          width: widget.width,
          height: widget.height,
          child: FilledButton(
            onPressed: effectiveOnPressed,
            style: widget.buttonStyle,
            child: widget.child,
          ),
        );
      case BondlyButtonStyle.outlined:
        return SizedBox(
          width: widget.width,
          height: widget.height,
          child: OutlinedButton(
            onPressed: effectiveOnPressed,
            style: widget.buttonStyle,
            child: widget.child,
          ),
        );
      case BondlyButtonStyle.text:
        return SizedBox(
          width: widget.width,
          height: widget.height,
          child: TextButton(
            onPressed: effectiveOnPressed,
            style: widget.buttonStyle,
            child: widget.child,
          ),
        );
    }
  }
}

class BondlyLoadingIconButton extends StatefulWidget {
  final bool isLoading;
  final VoidCallback? onPressed;
  final Widget icon;

  const BondlyLoadingIconButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    required this.icon,
  });

  @override
  State<BondlyLoadingIconButton> createState() =>
      _BondlyLoadingIconButtonState();
}

class _BondlyLoadingIconButtonState extends State<BondlyLoadingIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(covariant BondlyLoadingIconButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.isLoading && _controller.isAnimating) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacityAnimation,
      builder: (context, child) {
        final opacity = widget.isLoading ? _opacityAnimation.value : 1.0;
        return Opacity(
          opacity: opacity,
          child: IconButton(
            onPressed: widget.isLoading ? null : widget.onPressed,
            icon: widget.icon,
          ),
        );
      },
    );
  }
}
