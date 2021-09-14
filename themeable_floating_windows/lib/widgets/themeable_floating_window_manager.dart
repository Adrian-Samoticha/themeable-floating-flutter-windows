import 'package:flutter/material.dart';
import '../window_container/animation_properties.dart';
import '../window_container/window.dart';
import '../window_container/window_container.dart';
import 'window_back_frame.dart';
import 'window_front_frame.dart';

class ThemeableFloatingWindowManager extends StatefulWidget {
  final WindowContainer windowContainer;
  
  const ThemeableFloatingWindowManager({Key? key, required this.windowContainer}) : super(key: key);

  @override
  State<ThemeableFloatingWindowManager> createState() => _ThemeableFloatingWindowManagerState();
}

class _ThemeableFloatingWindowManagerState extends State<ThemeableFloatingWindowManager> {
  double _relativeSizeToAbsoluteSize(double relativeSize, double maxSize) {
    return relativeSize * maxSize;
  }

  @override
  Widget build(BuildContext context) {
    final windowList = widget.windowContainer.windowList;
    
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          clipBehavior: Clip.none,
          children: windowList.map((Window window) {
            final properties = window.properties;
            final position = window.renderPosition;
            
            return AnimatedPositioned(
              key: window.key,
              duration: window.positionChangeAnimationProperties.duration,
              curve: window.positionChangeAnimationProperties.curve,
              onEnd: () => window.positionChangeAnimationProperties = AnimationProperties.instant(),
              left: _relativeSizeToAbsoluteSize(position.left, constraints.maxWidth),
              top: _relativeSizeToAbsoluteSize(position.top, constraints.maxHeight),
              width: _relativeSizeToAbsoluteSize(position.width, constraints.maxWidth),
              height: _relativeSizeToAbsoluteSize(position.height, constraints.maxHeight),
              child: Stack(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return properties.backgroundBuilder(context, constraints, window);
                    }
                  ),
                  WindowBackFrame(
                    window: window,
                    constraints: constraints,
                    setState: setState
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.deferToChild,
                    onPanDown: (_) => setState(window.raise),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return properties.childBuilder(context, constraints, window);
                      }
                    ),
                  ),
                  WindowFrontFrame(
                    window: window,
                    constraints: constraints,
                    setState: setState
                  ),
                ]
              ),
            );
          }).toList(),
        );
      }
    );
  }
}