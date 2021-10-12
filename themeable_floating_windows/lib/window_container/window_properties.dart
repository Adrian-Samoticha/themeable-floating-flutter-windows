import 'dart:math';

import 'package:flutter/widgets.dart';

import 'window.dart';
import 'window_size.dart';

typedef WindowCallback = void Function(Window);

class WindowProperties {
  final Widget Function(BuildContext, BoxConstraints, Window) childBuilder;
  final Widget Function(BuildContext, BoxConstraints, Window) backgroundBuilder;
  bool doStayOnTop;
  bool isDraggable;
  bool isResizable;
  bool enableGrabCursor;
  double borderWidth;
  MutableRectangle<double> position;
  WindowSize minSize;
  bool isMaximized;
  bool isMinimized;
  Offset minimizationOffset = const Offset(0.0, 0.0);
  final MutableRectangle<double> Function()? getMaximizedPosition;
  
  final WindowCallback? onClose;
  final WindowCallback? onRaise;
  final WindowCallback? onMaximize;
  final WindowCallback? onMinimize;
  final WindowCallback? onRestore;
  final WindowCallback? onMaximizeOrRestore;
  final WindowCallback? onDragBegin;
  final WindowCallback? onDragUpdate;
  final WindowCallback? onDragEnd;
  final WindowCallback? onResizeBegin;
  final WindowCallback? onResizeUpdate;
  final WindowCallback? onResizeEnd;
  final void Function(Window, MutableRectangle<double>)? onPositionChanged;
  
  WindowProperties({
    required this.childBuilder,
    required this.backgroundBuilder,
    this.doStayOnTop = false,
    this.isDraggable = true,
    this.isResizable = true,
    this.enableGrabCursor = false,
    this.borderWidth = 8.0,
    required this.position,
    this.minSize = const WindowSize(0.1, 0.1),
    this.isMaximized = false,
    this.isMinimized = false,
    this.getMaximizedPosition,
    
    this.onClose,
    this.onRaise,
    this.onMaximize,
    this.onMinimize,
    this.onRestore,
    this.onMaximizeOrRestore,
    this.onDragBegin,
    this.onDragUpdate,
    this.onDragEnd,
    this.onResizeBegin,
    this.onResizeUpdate,
    this.onResizeEnd,
    this.onPositionChanged,
  });
}
