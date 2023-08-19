import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

/// Builder with which you can return a custom shape widget.
typedef ChaoticProgressShapeBuilder = Widget Function(
  BuildContext context,
  int index,
  Color color,

  /// The [scale] is calculated by dividing the random size by [maxShapeSize].
  /// The minimum value is minShapeSize/maxShapeSize and the maximum value is 1.
  double scale,
);

class ChaoticProgress extends StatefulWidget {
  const ChaoticProgress({
    super.key,
    required this.visible,
    this.numberOfShapes = 75,
    this.minShapeSize = 15.0,
    this.maxShapeSize = 40.0,
    this.minShapeOpacity = 0.5,
    this.maxShapeOpacity = 1.0,
    this.colors = const [
      Colors.redAccent,
      Colors.orangeAccent,
      Colors.greenAccent,
      Colors.purpleAccent,
      Colors.blueAccent,
      Colors.pinkAccent,
      Colors.blueGrey,
    ],
    this.shape = BoxShape.circle,
    this.alignCurve = Curves.easeInBack,
    this.figureCurve = Curves.linearToEaseOut,
    this.duration = const Duration(milliseconds: 1500),
    this.filter,
    this.backgroundColor,
    this.shapeBuilder,
  })  : assert(numberOfShapes > 0 && numberOfShapes <= 300),
        assert(
          minShapeOpacity >= 0 &&
              minShapeOpacity <= 1 &&
              minShapeOpacity <= maxShapeOpacity,
        ),
        assert(maxShapeOpacity >= 0 && maxShapeOpacity <= 1),
        assert(minShapeSize >= 1 && maxShapeSize >= minShapeSize),
        assert(colors.length > 0);

  /// The number of shapes to display.
  final int numberOfShapes;

  /// Switches between showing shapes and hiding them.
  final bool visible;

  /// Minimum figure size
  final double minShapeSize;

  /// Maximum figure size
  final double maxShapeSize;

  /// The fraction to scale the shape's alpha value.
  ///
  /// An opacity of 1.0 is fully opaque. An opacity of 0.0 is fully transparent
  /// (i.e., invisible).
  ///
  /// Minimum alpha value for shapes.
  final double minShapeOpacity;

  /// The fraction to scale the shape's alpha value.
  ///
  /// An opacity of 1.0 is fully opaque. An opacity of 0.0 is fully transparent
  /// (i.e., invisible).
  ///
  /// Maximum alpha value for shapes.
  final double maxShapeOpacity;

  /// The shape of the displayed figure.
  final BoxShape shape;

  /// List of colors that will be randomly selected to display one of the shapes.
  final List<Color> colors;

  /// The curve to apply when animating the parameters of this figure.
  final Curve figureCurve;

  /// The curve to apply when animating the parameters of this align.
  final Curve alignCurve;

  /// The image filter to apply to the existing painted content before painting
  /// the child.
  ///
  /// For example, consider using [ImageFilter.blur] to create a backdrop
  /// blur effect.
  final ImageFilter? filter;

  /// The duration over which to animate the align and size of this shapes.
  final Duration duration;

  /// The color to fill in the background.
  ///
  /// The [backgroundColor] is drawn under the figures.
  final Color? backgroundColor;

  /// Builder with which you can return a custom shape widget.
  ///
  /// ChaoticProgress(
  ///   visible: true,
  ///   alignCurve: Curves.linear,
  ///   duration: const Duration(seconds: 5),
  ///   shapeBuilder: (context, index, color, scale) => AnimatedBuilder(
  ///     animation: _animationController,
  ///     builder: (_, child) => Transform.rotate(
  ///       angle: -2 * 3.1415926 * _animationController.value,
  ///       child: child,
  ///     ),
  ///     child: AnimatedScale(
  ///       scale: scale,
  ///       duration: const Duration(seconds: 1),
  ///       child: const Icon(
  ///         Icons.ac_unit,
  ///         color: Colors.lightBlueAccent,
  ///         size: 36,
  ///       ),
  ///     ),
  ///   ),
  /// )
  final ChaoticProgressShapeBuilder? shapeBuilder;

  @override
  State<ChaoticProgress> createState() => _ChaoticProgressState();
}

class _ChaoticProgressState extends State<ChaoticProgress>
    with SingleTickerProviderStateMixin {
  late final _animationController = AnimationController(
    vsync: this,
    duration: widget.duration,
  );

  final _random = Random();

  Alignment get _alignment => Alignment(
        _random.nextDouble() * 2 - 1,
        _random.nextDouble() * 2 - 1,
      );

  double get _shapeSize => _next(
        widget.minShapeSize,
        widget.maxShapeSize,
      );

  Color get _color {
    final index = _random.nextInt(widget.colors.length);
    final color = widget.colors[index];
    final opacity = _next(widget.minShapeOpacity, widget.maxShapeOpacity);
    return color.withOpacity(opacity);
  }

  double _next(double min, double max) =>
      _random.nextDouble() * (max - min) + min;

  @override
  void initState() {
    super.initState();
    _animationController
      ..forward()
      ..addListener(_listener)
      ..addStatusListener(_statusListener);
  }

  void _listener() {
    setState(() {});
    _animationController.removeListener(_listener);
  }

  void _statusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _animationController.forward(from: 0);
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(covariant ChaoticProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.visible != widget.visible) {
      widget.visible
          ? _animationController.forward(from: 0)
          : _animationController.stop(canceled: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child = Stack(
      fit: StackFit.expand,
      children: List.generate(
        growable: false,
        widget.numberOfShapes,
        (index) {
          final shapeSize = _shapeSize;
          final color = _color;
          return _Shape(
            size: shapeSize,
            color: color,
            shape: widget.shape,
            alignCurve: widget.alignCurve,
            figureCurve: widget.figureCurve,
            duration: widget.duration,
            alignment: _alignment,
            child: widget.shapeBuilder?.call(
              context,
              index,
              color,
              shapeSize / widget.maxShapeSize,
            ),
          );
        },
      ),
    );

    if (widget.backgroundColor != null) {
      child = ColoredBox(
        color: widget.backgroundColor!,
        child: child,
      );
    }

    if (widget.filter != null) {
      child = ClipRect(
        child: BackdropFilter(
          filter: widget.filter!,
          child: child,
        ),
      );
    }
    return AnimatedOpacity(
      opacity: widget.visible ? 1 : 0,
      duration: const Duration(milliseconds: 300),
      child: child,
    );
  }

  @override
  void dispose() {
    _animationController
      ..removeStatusListener(_statusListener)
      ..dispose();
    super.dispose();
  }
}

class _Shape extends StatelessWidget {
  const _Shape({
    required this.size,
    required this.color,
    required this.shape,
    required this.alignCurve,
    required this.figureCurve,
    required this.duration,
    required this.alignment,
    required this.child,
  });

  final double size;
  final Color color;
  final BoxShape shape;
  final Curve alignCurve;
  final Curve figureCurve;
  final Duration duration;
  final Alignment alignment;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return AnimatedAlign(
      curve: alignCurve,
      duration: duration,
      alignment: alignment,
      child: child ??
          AnimatedContainer(
            width: size,
            height: size,
            curve: figureCurve,
            duration: duration,
            decoration: BoxDecoration(
              color: color,
              shape: shape,
            ),
          ),
    );
  }
}
