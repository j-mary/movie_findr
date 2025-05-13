import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:movie_findr/core/index.dart';

/// Modified version of https://github.com/spporan/FlutterOverlayLoader/blob/master/lib/flutter_overlay_loader.dart

class Loader extends StatefulWidget {
  static OverlayEntry? _currentLoader;

  const Loader._(this._progressIndicator, this._themeData);

  final Widget? _progressIndicator;
  final ThemeData? _themeData;
  static OverlayState? _overlayState;

  static bool get isLoading => _currentLoader != null;

  static void show(
    BuildContext context, {
    Widget? progressIndicator,
    ThemeData? themeData,
    Color? overlayColor,
  }) {
    _overlayState = Overlay.of(context);
    if (_currentLoader == null) {
      _currentLoader = OverlayEntry(
        builder: (context) => Stack(
          children: <Widget>[
            SafeArea(
              child: Builder(
                builder: (context) {
                  final theme = Theme.of(context);
                  return Container(
                    color: overlayColor ??
                        theme.colorScheme.primary.withValues(alpha: 0.7),
                  );
                },
              ),
            ),
            Center(
              child: Loader._(
                progressIndicator,
                themeData,
              ),
            ),
          ],
        ),
      );
      try {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final loader = _currentLoader;
          if (loader == null) return;
          _overlayState?.insert(loader);
        });
      } catch (e, s) {
        hide();
        if (kDebugMode) {
          print(e);
          print(s);
        }
      }
    }
  }

  static void hide() {
    final loader = _currentLoader;
    if (loader != null) {
      try {
        loader.remove();
      } catch (e) {
        if (kDebugMode) log(e.toString());
      } finally {
        _currentLoader = null;
      }
    }
  }

  @override
  State<Loader> createState() => LoaderState();
}

class LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Theme(
        data: widget._themeData ?? ThemeData.light(),
        child: RotationTransition(
          turns: _controller,
          child: widget._progressIndicator ??
              Image.asset(
                kImgLoaderIcon,
              ),
        ),
      ),
    );
  }
}
