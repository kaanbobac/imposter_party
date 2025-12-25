import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

enum PremiumButtonStyle {
  primary,
  secondary,
  danger,
  success,
  glassmorphic,
}

class PremiumButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final PremiumButtonStyle style;
  final IconData? icon;
  final bool isLoading;
  final double? width;
  final double height;
  final bool isExpanded;

  const PremiumButton({
    super.key,
    required this.text,
    this.onPressed,
    this.style = PremiumButtonStyle.primary,
    this.icon,
    this.isLoading = false,
    this.width,
    this.height = 56,
    this.isExpanded = false,
  });

  @override
  State<PremiumButton> createState() => _PremiumButtonState();
}

class _PremiumButtonState extends State<PremiumButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
    HapticFeedback.lightImpact();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  Color _getBackgroundColor() {
    switch (widget.style) {
      case PremiumButtonStyle.primary:
        return const Color(0xFF4ECDC4);
      case PremiumButtonStyle.secondary:
        return const Color(0xFF6C5CE7);
      case PremiumButtonStyle.danger:
        return const Color(0xFFFF6B6B);
      case PremiumButtonStyle.success:
        return const Color(0xFF26DE81);
      case PremiumButtonStyle.glassmorphic:
        return Colors.white.withValues(alpha: 0.1);
    }
  }

  List<BoxShadow> _getBoxShadows() {
    final color = _getBackgroundColor();

    if (widget.style == PremiumButtonStyle.glassmorphic) {
      return [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: Colors.white.withValues(alpha: 0.1),
          blurRadius: 10,
          offset: const Offset(0, -2),
        ),
      ];
    }

    return _isPressed
        ? [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ]
        : [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: color.withValues(alpha: 0.2),
              blurRadius: 40,
              offset: const Offset(0, 16),
            ),
          ];
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null && !widget.isLoading;
    final width = widget.isExpanded ? double.infinity : widget.width;

    return GestureDetector(
      onTapDown: isEnabled ? _onTapDown : null,
      onTapUp: isEnabled ? _onTapUp : null,
      onTapCancel: isEnabled ? _onTapCancel : null,
      onTap: isEnabled ? widget.onPressed : null,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final scale = 1.0 - (_controller.value * 0.05);

          return Transform.scale(
            scale: scale,
            child: Container(
              width: width,
              height: widget.height,
              decoration: BoxDecoration(
                gradient: widget.style == PremiumButtonStyle.glassmorphic
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: 0.1),
                          Colors.white.withValues(alpha: 0.05),
                        ],
                      )
                    : LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          _getBackgroundColor(),
                          _getBackgroundColor().withValues(alpha: 0.8),
                        ],
                      ),
                borderRadius: BorderRadius.circular(16),
                border: widget.style == PremiumButtonStyle.glassmorphic
                    ? Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1,
                      )
                    : null,
                boxShadow: isEnabled ? _getBoxShadows() : [],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: widget.style == PremiumButtonStyle.glassmorphic
                      ? BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withValues(alpha: 0.1),
                              Colors.white.withValues(alpha: 0.05),
                            ],
                          ),
                        )
                      : null,
                  child: Material(
                    color: Colors.transparent,
                    child: Center(
                      child: widget.isLoading
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  widget.style == PremiumButtonStyle.glassmorphic
                                      ? Colors.white
                                      : Colors.white,
                                ),
                              ),
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (widget.icon != null) ...[
                                  Icon(
                                    widget.icon,
                                    color: widget.style == PremiumButtonStyle.glassmorphic
                                        ? const Color(0xFF4ECDC4)
                                        : Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                ],
                                Text(
                                  widget.text,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: widget.style == PremiumButtonStyle.glassmorphic
                                        ? Colors.white
                                        : Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    )
        .animate(target: isEnabled ? 1 : 0)
        .fade(duration: 200.ms)
        .scale(begin: const Offset(0.95, 0.95));
  }
}