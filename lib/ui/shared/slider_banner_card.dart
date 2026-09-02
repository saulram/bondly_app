import 'dart:async';

import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/dimensions.dart';
import 'package:bondly_app/ui/shared/slider_dots_indicator.dart';
import 'package:bondly_app/ui/shared/tag_pill.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class BannerItem {
  final String? tag;
  final String title;
  final String? subtitle;
  final String? image;

  const BannerItem({this.tag, required this.title, this.subtitle, this.image});
}

class SliderBannerCard extends StatefulWidget {
  final List<BannerItem> items;
  final Duration autoPlayDuration;
  final VoidCallback? onRetry;
  final bool isLoading;
  final String? errorMessage;

  const SliderBannerCard({
    super.key,
    required this.items,
    this.autoPlayDuration = const Duration(seconds: 5),
    this.onRetry,
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  State<SliderBannerCard> createState() => _SliderBannerCardState();
}

class _SliderBannerCardState extends State<SliderBannerCard> {
  late final PageController _pageController;
  late final FocusNode _focusNode;
  int _currentPage = 0;
  Timer? _autoPlayTimer;
  bool _hovering = false;
  bool _focused = false;
  bool _touching = false;
  bool _dragging = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _focusNode = FocusNode(debugLabel: 'SliderBannerCard');
    _startAutoPlay();
  }

  @override
  void didUpdateWidget(covariant SliderBannerCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items ||
        oldWidget.autoPlayDuration != widget.autoPlayDuration) {
      _currentPage = widget.items.isEmpty
          ? 0
          : _currentPage.clamp(0, widget.items.length - 1);
      _restartAutoPlay();
      if (widget.items.isNotEmpty && _pageController.hasClients) {
        _pageController.jumpToPage(_currentPage);
      }
    }
  }

  void _startAutoPlay() {
    if (widget.items.length <= 1 || widget.autoPlayDuration <= Duration.zero) {
      return;
    }
    _autoPlayTimer = Timer.periodic(widget.autoPlayDuration, (_) {
      if (_isPaused) return;
      if (!mounted) return;
      if (widget.items.length < 2 || !_pageController.hasClients) return;
      final next = (_currentPage + 1) % widget.items.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  void _restartAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = null;
    _startAutoPlay();
  }

  bool get _isPaused => _hovering || _focused || _touching || _dragging;

  void _setPauseState(void Function() update) {
    if (!mounted) return;
    final wasPaused = _isPaused;
    setState(update);
    if (wasPaused != _isPaused && !_isPaused) {
      // A resumed timer starts its next interval from the interaction end.
      _restartAutoPlay();
    }
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;
    if (widget.isLoading) {
      return _stateBox(context, const CircularProgressIndicator());
    }
    if (widget.errorMessage != null) {
      return _stateBox(
          context,
          Column(mainAxisSize: MainAxisSize.min, children: [
            Text(widget.errorMessage!,
                style: const TextStyle(color: Colors.white)),
            if (widget.onRetry != null) ...[
              const SizedBox(height: 8),
              TextButton(
                  onPressed: widget.onRetry, child: const Text('Reintentar')),
            ],
          ]));
    }
    if (widget.items.isEmpty) {
      return _stateBox(
          context,
          const Text('No hay novedades disponibles',
              style: TextStyle(color: Colors.white)));
    }
    return Focus(
      focusNode: _focusNode,
      canRequestFocus: true,
      onFocusChange: (hasFocus) => _setPauseState(() => _focused = hasFocus),
      onKeyEvent: (_, event) {
        if (event is! KeyDownEvent || widget.items.length < 2) {
          return KeyEventResult.ignored;
        }
        if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
          _goTo(-1);
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
          _goTo(1);
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: MouseRegion(
        onEnter: (_) => _setPauseState(() => _hovering = true),
        onExit: (_) => _setPauseState(() => _hovering = false),
        child: Listener(
          // Track touch without asking Flutter to move keyboard focus. The
          // PageView owns horizontal gesture recognition below.
          onPointerDown: (event) {
            if (event.kind == PointerDeviceKind.touch ||
                event.kind == PointerDeviceKind.stylus) {
              _setPauseState(() => _touching = true);
            }
          },
          onPointerUp: (event) {
            if (event.kind == PointerDeviceKind.touch ||
                event.kind == PointerDeviceKind.stylus) {
              _setPauseState(() => _touching = false);
            }
          },
          onPointerCancel: (event) {
            if (event.kind == PointerDeviceKind.touch ||
                event.kind == PointerDeviceKind.stylus) {
              _setPauseState(() => _touching = false);
            }
          },
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification.depth != 0) return false;
              if (notification is ScrollStartNotification &&
                  notification.dragDetails != null) {
                _setPauseState(() => _dragging = true);
              } else if (notification is ScrollEndNotification && _dragging) {
                _setPauseState(() => _dragging = false);
              }
              return false;
            },
            child: SizedBox(
              height: 180,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: widget.items.length,
                    onPageChanged: (i) => setState(() => _currentPage = i),
                    itemBuilder: (context, index) {
                      final item = widget.items[index];
                      return Semantics(
                        container: true,
                        focusable: true,
                        label:
                            '${item.title}${item.subtitle == null ? '' : ': ${item.subtitle}'}',
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(AppDimensions.radiusPost),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                if (item.image != null)
                                  Image.network(item.image!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          const SizedBox.shrink()),
                                DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      colors.accent.withValues(alpha: .88),
                                      Colors.deepPurple.withValues(alpha: .82)
                                    ]),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(
                                      AppDimensions.paddingScreen),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (item.tag != null)
                                        TagPill(
                                          label: item.tag!,
                                          backgroundColor: BondlyColors.white
                                              .withValues(alpha: 0.2),
                                          textColor: BondlyColors.white,
                                        ),
                                      if (item.tag != null)
                                        const SizedBox(height: 10),
                                      Text(
                                        item.title,
                                        style: GoogleFonts.montserrat(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: BondlyColors.white,
                                          height: 1.15,
                                        ),
                                      ),
                                      if (item.subtitle != null) ...[
                                        const SizedBox(height: 6),
                                        Text(
                                          item.subtitle!,
                                          style: GoogleFonts.montserrat(
                                            fontSize: 13,
                                            color: BondlyColors.white
                                                .withValues(alpha: 0.8),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  if (widget.items.length > 1)
                    Positioned(
                      bottom: 12,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: SliderDotsIndicator(
                          count: widget.items.length,
                          activeIndex: _currentPage,
                        ),
                      ),
                    ),
                  if (widget.items.length > 1) ...[
                    Positioned(
                        left: 8,
                        top: 0,
                        bottom: 0,
                        child: _arrow(
                            Icons.chevron_left, () => _goTo(-1), 'Anterior')),
                    Positioned(
                        right: 8,
                        top: 0,
                        bottom: 0,
                        child: _arrow(
                            Icons.chevron_right, () => _goTo(1), 'Siguiente')),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _stateBox(BuildContext context, Widget child) => Container(
        height: 180,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
            gradient: AppDimensions.accentGradient(
                Theme.of(context).extension<BondlyColorScheme>()!),
            borderRadius: BorderRadius.circular(AppDimensions.radiusPost)),
        alignment: Alignment.center,
        child: child,
      );

  Widget _arrow(IconData icon, VoidCallback onPressed, String label) =>
      Semantics(
        button: true,
        label: label,
        child: IconButton(
            onPressed: onPressed,
            icon: Icon(icon, color: Colors.white),
            tooltip: label),
      );

  void _goTo(int delta) {
    if (!_pageController.hasClients || widget.items.length < 2) return;
    final next =
        (_currentPage + delta + widget.items.length) % widget.items.length;
    _pageController.animateToPage(next,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }
}
