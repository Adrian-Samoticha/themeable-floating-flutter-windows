import 'package:flutter/widgets.dart';

/// The properties of a [Window]'s Animation.
class AnimationProperties {
  final Duration duration;
  final Curve curve;

  /// Creates an animation with a given [duration] and [curve].
  AnimationProperties({required this.duration, this.curve = Curves.linear});
  
  /// Creates an animation that completes instantly, that is, one that does not play at all.
  AnimationProperties.instant()
  : duration = const Duration(),
    curve = Curves.linear;
  
  /// Creates a linar animation with a given [duration].
  AnimationProperties.linear(this.duration)
  : curve = Curves.linear;
  
  /// Creates an ease animation with a given [duration].
  AnimationProperties.ease(this.duration)
  : curve = Curves.ease;
}