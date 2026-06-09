import 'dart:ui' as ui;

import 'package:all_benefits_group/app/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AppImage extends StatefulWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final bool isOval;
  final int? cacheWidth;
  final int? cacheHeight;

  const AppImage({
    required this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.isOval = false,
    this.cacheWidth,
    this.cacheHeight,
    super.key,
  });

  @override
  State<AppImage> createState() => _AppImageState();
}

class _AppImageState extends State<AppImage> with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    // Start fade-in immediately
    _fadeController.forward();
  }

  ImageProvider _getImageProvider() {
    if (widget.assetPath.startsWith('http')) {
      return NetworkImage(widget.assetPath);
    }
    return AssetImage(widget.assetPath);
  }

  bool _isNetworkImage() => widget.assetPath.startsWith('http');

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageWidget = _isNetworkImage()
        ? Image.network(
            widget.assetPath,
            width: widget.width,
            height: widget.height,
            fit: widget.fit,
            cacheWidth: widget.cacheWidth,
            cacheHeight: widget.cacheHeight,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: widget.borderRadius,
                ),
                child: const Center(
                  child: Icon(Icons.broken_image_outlined),
                ),
              );
            },
          )
        : Image.asset(
            widget.assetPath,
            width: widget.width,
            height: widget.height,
            fit: widget.fit,
            cacheWidth: widget.cacheWidth,
            cacheHeight: widget.cacheHeight,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: widget.borderRadius,
                ),
                child: const Center(
                  child: Icon(Icons.broken_image_outlined),
                ),
              );
            },
          );

    final image = AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: child,
        );
      },
      child: imageWidget,
    );

    if (widget.isOval) {
      return ClipOval(child: image);
    }

    if (widget.borderRadius != null) {
      return ClipRRect(
        borderRadius: widget.borderRadius!,
        child: image,
      );
    }

    return image;
  }
}

class _BlurryPlaceholder extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const _BlurryPlaceholder({
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.line,
        borderRadius: borderRadius,
      ),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
          ),
          child: const Center(
            child: SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color(0xFFFF6B1A),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
