import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../window_container/animation_properties.dart';
import '../window_container/window.dart';

class WindowBackFrame extends StatelessWidget {
  final Window window;
  final BoxConstraints constraints;
  final void Function(void Function()) setState;
  
  const WindowBackFrame({Key? key, required this.window, required this.constraints, required this.setState}) : super(key: key);
  
  double _absoluteSizeToRelativeSize(double absoluteSize, double maxSize) {
    return absoluteSize / maxSize;
  }
  
  MouseCursor get _defaultMouseCursor {
    if (window.properties.isDraggable && window.properties.enableGrabCursor) {
      return window.isBeingDragged ? SystemMouseCursors.grabbing : SystemMouseCursors.grab;
    }
    
    return MouseCursor.defer;
  }
  
  void _moveWindowToCursor(Offset cursorPosition) {
    final relativeCursorPosition = Offset(
      _absoluteSizeToRelativeSize(cursorPosition.dx, constraints.maxWidth),
      _absoluteSizeToRelativeSize(cursorPosition.dy, constraints.maxHeight),
    );
    
    final position = window.properties.position;
    
    var x = position.left;
    x = min(x, relativeCursorPosition.dx);
    x = max(x, relativeCursorPosition.dx - position.width);
    
    var y = position.top;
    y = min(y, relativeCursorPosition.dy);
    y = max(y, relativeCursorPosition.dy - position.height);
    
    window.moveTo(
      Offset(x, y),
      AnimationProperties.instant
    );
  }
  
  void _startDrag(DragStartDetails dragStartDetails) {
    setState(() {
      window.isBeingDragged = true;
    });
    window.triggerOnDragBeginCallback();
  }
  
  void _updateDrag(DragUpdateDetails dragUpdateDetails) {
    if (window.properties.isMaximized) {
      window.restore(AnimationProperties.instant);
      _moveWindowToCursor(dragUpdateDetails.localPosition);
    }
    
    setState(() {
      window.move(Offset(
        _absoluteSizeToRelativeSize(dragUpdateDetails.delta.dx, constraints.maxWidth),
        _absoluteSizeToRelativeSize(dragUpdateDetails.delta.dy, constraints.maxHeight),
      ), AnimationProperties.instant);
    });
    window.triggerOnDragUpdateCallback();
  }
  
  void _endDrag(DragEndDetails dragEndDetails) {
    setState(() {
      window.isBeingDragged = false;
    });
    window.triggerOnDragEndCallback();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (_) => setState(window.raise),
      onPanStart: _startDrag,
      onPanUpdate: _updateDrag,
      onPanEnd: _endDrag,
      child: MouseRegion(
        cursor: _defaultMouseCursor,
      ),
    );
  }
}