import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../window_container/animation_properties.dart';
import '../window_container/window.dart';

class WindowFrontFrame extends StatelessWidget {
  final Window window;
  final BoxConstraints constraints;
  final void Function(void Function()) setState;
  
  const WindowFrontFrame({Key? key, required this.window, required this.constraints, required this.setState}) : super(key: key);
  
  double get _actualBorderWidth {
    if (!window.properties.isResizable) return 0.0;
    if (window.properties.isMaximized) return 0.0;
    
    return window.properties.borderWidth;
  }
  
  double _absoluteSizeToRelativeSize(double absoluteSize, double maxSize) {
    return absoluteSize / maxSize;
  }
  
  void _startResize(DragStartDetails dragStartDetails, int row, int column) {
    setState(() {
      window.isBeingResized = true;
    });
    window.triggerOnResizeBeginCallback();
  }
  
  void _updateResize(DragUpdateDetails dragUpdateDetails, int row, int column) {
    setState(() {
      final offsetX = _absoluteSizeToRelativeSize(dragUpdateDetails.delta.dx, constraints.maxWidth);
      final offsetY = _absoluteSizeToRelativeSize(dragUpdateDetails.delta.dy, constraints.maxHeight);
      
      final resizeX = row == 0 ? -offsetX :
                      row == 1 ? 0.0 :
                                 offsetX;
      final resizeY = column == 0 ? -offsetY :
                      column == 1 ? 0.0 :
                                    offsetY;
      
      final sizeDifference = window.resize(Offset(resizeX, resizeY), AnimationProperties.instant);
      
      window.move(Offset(
        row == 0 ? -sizeDifference.dx : 0.0,
        column == 0 ? -sizeDifference.dy : 0.0,
      ), AnimationProperties.instant);
    });
    window.triggerOnResizeUpdateCallback();
  }
  
  void _endResize(DragEndDetails dragEndDetails, int row, int column) {
    setState(() {
      window.isBeingResized = false;
    });
    window.triggerOnResizeEndCallback();
  }
  
  Widget _generateRow(int column) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onPanDown: (_) => setState(window.raise),
          onPanStart: (d) => _startResize(d, 0, column),
          onPanUpdate: (d) => _updateResize(d, 0, column),
          onPanEnd: (d) => _endResize(d, 0, column),
          child: MouseRegion(
            opaque: true,
            cursor: column == 0 ? SystemMouseCursors.resizeUpLeft :
                    column == 1 ? SystemMouseCursors.resizeLeftRight :
                                  SystemMouseCursors.resizeDownLeft,
            child: SizedBox(
              width: _actualBorderWidth,
            ),
          ),
        ),
        Expanded(
          child: column == 1 ? const SizedBox() : GestureDetector(
            behavior: HitTestBehavior.translucent,
            onPanDown: (_) => setState(window.raise),
            onPanStart: column == 1 ? null : (d) => _startResize(d, 1, column),
            onPanUpdate: column == 1 ? null : (d) => _updateResize(d, 1, column),
            onPanEnd: column == 1 ? null : (d) => _endResize(d, 1, column),
            child: MouseRegion(
              opaque: column != 1,
              cursor: column == 0 ? SystemMouseCursors.resizeUpDown :
                      column == 1 ? MouseCursor.defer :
                                    SystemMouseCursors.resizeUpDown,
            ),
          ),
        ),
        GestureDetector(
          onPanDown: (_) => setState(window.raise),
          onPanStart: (d) => _startResize(d, 2, column),
          onPanUpdate: (d) => _updateResize(d, 2, column),
          onPanEnd: (d) => _endResize(d, 2, column),
          child: MouseRegion(
            opaque: true,
            cursor: column == 0 ? SystemMouseCursors.resizeUpRight :
                    column == 1 ? SystemMouseCursors.resizeLeftRight :
                                  SystemMouseCursors.resizeDownRight,
            child: SizedBox(
              width: _actualBorderWidth,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: _actualBorderWidth,
          child: _generateRow(0),
        ),
        Expanded(
          child: _generateRow(1),
        ),
        SizedBox(
          height: _actualBorderWidth,
          child: _generateRow(2),
        ),
      ]
    );
  }
}