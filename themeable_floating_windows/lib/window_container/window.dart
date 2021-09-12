import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:quiver/core.dart';

import '../themeable_floating_windows.dart';
import 'window_container.dart';
import 'window_properties.dart';

class Window {
  final Key key;
  final WindowContainer windowContainer;
  WindowProperties properties;
  bool isBeingDragged = false;
  bool isBeingResized = false;
  Duration positionChangeDuration = const Duration();
  Curve positionChangeCurve = Curves.linear;
  dynamic metaData;

  Window(this.key, this.windowContainer, this.properties);
  
  WindowSize get size => WindowSize(properties.position.width, properties.position.height);
  
  @override
  bool operator ==(Object other) {
    return other is Window && other.key == key;
  }
  
  @override
  int get hashCode {
    return hashObjects([key]);
  }
  
  MutableRectangle<double> get renderPosition {
    if (properties.isMaximized) {
      return MutableRectangle<double>(0.0, 0.0, 1.0, 1.0);
    }
    
    return properties.position;
  }
  
  /// Closes the window.
  void close() {
    windowContainer.closeWindow(this);
  }
  
  /// Raises the window.
  void raise() {
    windowContainer.raiseWindow(this);
  }
  
  /// Moves the window.
  void move(Offset relativeAmount, Duration duration, Curve curve) {
    windowContainer.moveWindow(this, relativeAmount, duration, curve);
  }
  
  /// Moves the window.
  void moveTo(Offset position, Duration duration, Curve curve) {
    windowContainer.moveWindowTo(this, position, duration, curve);
  }
  
  /// Resizes the window.
  ///
  /// If the final size of the window were to be smaller than [minSize]
  /// the size will be capped at [minSize].
  /// Returns the actual amount by which the window has been resized.
  Offset resize(Offset relativeAmount, Duration duration, Curve curve) {
   return windowContainer.resizeWindow(this, relativeAmount, duration, curve);
  }
  
  /// Maximizes the window.
  void maximize(Duration duration, Curve curve) {
    windowContainer.maximizeWindow(this, duration, curve);
  }
  
  /// Restores the window.
  void restore(Duration duration, Curve curve) {
    windowContainer.restoreWindow(this, duration, curve);
  }
  
  /// Triggers the window's [onClose] callback.
  void triggerOnCloseCallback() {
    if (properties.onClose != null) {
      properties.onClose!(this);
    }
  }
  
  /// Triggers the window's [onRaise] callback.
  void triggerOnRaiseCallback() {
    if (properties.onRaise != null) {
      properties.onRaise!(this);
    }
  }
  
  /// Triggers the window's [onMaximize] callback.
  void triggerOnMaximizeCallback() {
    if (properties.onMaximize != null) {
      properties.onMaximize!(this);
    }
  }
  
  /// Triggers the window's [onMinimize] callback.
  void triggerOnMinimizeCallback() {
    if (properties.onMinimize != null) {
      properties.onMinimize!(this);
    }
  }
  
  /// Triggers the window's [onRestore] callback.
  void triggerOnRestoreCallback() {
    if (properties.onRestore != null) {
      properties.onRestore!(this);
    }
  }
  
  /// Triggers the window's [onMaximizeOrRestore] callback.
  void triggerOnMaximizeOrRestoreCallback() {
    if (properties.onMaximizeOrRestore != null) {
      properties.onMaximizeOrRestore!(this);
    }
  }
  
  /// Triggers the window's [onDragBegin] callback.
  void triggerOnDragBeginCallback() {
    if (properties.onDragBegin != null) {
      properties.onDragBegin!(this);
    }
  }
  
  /// Triggers the window's [onDragUpdate] callback.
  void triggerOnDragUpdateCallback() {
    if (properties.onDragUpdate != null) {
      properties.onDragUpdate!(this);
    }
  }
  
  /// Triggers the window's [onDragEnd] callback.
  void triggerOnDragEndCallback() {
    if (properties.onDragEnd != null) {
      properties.onDragEnd!(this);
    }
  }
  
  /// Triggers the window's [onResizeBegin] callback.
  void triggerOnResizeBeginCallback() {
    if (properties.onResizeBegin != null) {
      properties.onResizeBegin!(this);
    }
  }
  
  /// Triggers the window's [onResizeUpdate] callback.
  void triggerOnResizeUpdateCallback() {
    if (properties.onResizeUpdate != null) {
      properties.onResizeUpdate!(this);
    }
  }
  
  /// Triggers the window's [onResizeEnd] callback.
  void triggerOnResizeEndCallback() {
    if (properties.onResizeEnd != null) {
      properties.onResizeEnd!(this);
    }
  }
  
  /// Triggers the window's [onPositionChanged] callback.
  void triggerOnPositionChangedCallback() {
    if (properties.onPositionChanged != null) {
      properties.onPositionChanged!(this, properties.position);
    }
  }
}