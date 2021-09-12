import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:themeable_floating_windows/window_container/window.dart';

class WindowBackFrame extends StatelessWidget {
  final Window window;
  final BoxConstraints constraints;
  final void Function(void Function()) setState;
  
  const WindowBackFrame({Key? key, required this.window, required this.constraints, required this.setState}) : super(key: key);
  
  double _realSizeToRelativeSize(double realSize, double maxSize) {
    return realSize / maxSize;
  }
  
  MouseCursor get _defaultMouseCursor {
    if (window.properties.isDraggable && window.properties.enableGrabCursor) {
      return window.isBeingDragged ? SystemMouseCursors.grabbing : SystemMouseCursors.grab;
    }
    
    return MouseCursor.defer;
  }
  
  void _startDrag(DragStartDetails dragStartDetails) {
    setState(() {
      window.isBeingDragged = true;
    });
    window.triggerOnDragBeginCallback();
  }
  
  void _updateDrag(DragUpdateDetails dragUpdateDetails) {
    if (window.properties.isMaximized) {
      window.restore(const Duration(), Curves.linear);
      window.moveTo(Offset(window.properties.position.left, 0.0), const Duration(), Curves.linear);
    }
    
    setState(() {
      window.move(Offset(
        _realSizeToRelativeSize(dragUpdateDetails.delta.dx, constraints.maxWidth),
        _realSizeToRelativeSize(dragUpdateDetails.delta.dy, constraints.maxHeight),
      ), const Duration(), Curves.linear);
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