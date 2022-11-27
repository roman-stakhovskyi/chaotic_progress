<p align="center">
<a href="https://pub.dev/packages/chaotic_progress"><img src="https://img.shields.io/pub/v/chaotic_progress.svg" alt="Pub"></a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
</p>

## Features

<img src="https://raw.githubusercontent.com/roman-stakhovskyi/chaotic_progress/master/assets/demo.gif"  width="400"/>

## Getting Started

In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
  ...
  chaotic_progress: any
```

Import it:

```dart
import 'package:chaotic_progress/chaotic_progress.dart';
```

## Usage

```dart
ChaoticProgress(
  visible: true,
  backgroundColor: Colors.white.withOpacity(0.5),
  filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
  alignCurve: Curves.linear,
  duration: const Duration(seconds: 4),
  // Use this if you want to add a custom shape
  shapeBuilder: (context, index) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (_, child) {
        return Transform.rotate(
          angle: _animationController.value * -2 * 3.1415926,
          child: child,
        );
      },
    child: const Icon(
      Icons.ac_unit,
      color: Colors.lightBlueAccent,
      size: 36,
    ),
  );
 },
);
```

## Parameters

You can read all the information about ChaoticProgress properties below.

```dart
class ChaoticProgress extends StatefulWidget {
const ChaoticProgress({
        super.key,
        this.numberOfShapes = 75,
        this.visible = true,
        this.minShapeSize = 15.0,
        this.maxShapeSize = 40.0,
        this.minShapeOpacity = 0.5,
        this.maxShapeOpacity = 1.0,
        this.colors = const [
        Colors.redAccent,
        Colors.greenAccent,
        Colors.blueAccent,
        ],
        this.shape = BoxShape.circle,
        this.alignCurve = Curves.easeInBack,
        this.figureCurve = Curves.linearToEaseOut,
        this.duration = const Duration(milliseconds: 1500),
        this.filter,
        this.backgroundColor,
        this.shapeBuilder,
});

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
final ChaoticProgressShapeBuilder? shapeBuilder;
```
