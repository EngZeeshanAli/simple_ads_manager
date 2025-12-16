import 'package:flutter/material.dart';

class SimpleOverlay {
  static OverlayEntry? _overlay;

  /// Show full-screen overlay
  static void show(BuildContext context,
      {Color backgroundColor = Colors.black}) {
    if (_overlay != null) return;

    _overlay = OverlayEntry(
      builder: (context) => Material(
        color: backgroundColor,
      ),
    );

    Overlay.of(context).insert(_overlay!);
  }

  /// Dismiss overlay
  static void dismiss() {
    _overlay?.remove();
    _overlay = null;
  }
}
