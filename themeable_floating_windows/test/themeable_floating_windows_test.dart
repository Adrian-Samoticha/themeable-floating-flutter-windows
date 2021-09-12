import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:themeable_floating_windows/themeable_floating_windows.dart';
import 'package:themeable_floating_windows/window_container/window.dart';


WindowContainer getWindowContainerWithXOpenWindows(int numberOfWindows, {
  WindowCallback? onClose,
  WindowCallback? onRaise,
  WindowCallback? onMaximize,
  WindowCallback? onMinimize,
  WindowCallback? onRestore,
  WindowCallback? onMaximizeOrRestore,
  WindowCallback? onDragBegin,
  WindowCallback? onDragUpdate,
  WindowCallback? onDragEnd,
  WindowCallback? onResizeBegin,
  WindowCallback? onResizeUpdate,
  WindowCallback? onResizeEnd,
}) {
  final container = WindowContainer();
    
  
  for (int i = 0; i < numberOfWindows; i++) {
    final window = container.openWindow(
      WindowProperties(
        childBuilder: (context, constraints, window) => const SizedBox(),
        backgroundBuilder: (context, constraints, window) => const SizedBox(),
        position: MutableRectangle<double>(0.0, 0.0, 1.0, 1.0),
        onClose: onClose,
        onRaise: onRaise,
        onMaximize: onMaximize,
        onMinimize: onMinimize,
        onRestore: onRestore,
        onMaximizeOrRestore: onMaximizeOrRestore,
        onDragBegin: onDragBegin,
        onDragUpdate: onDragUpdate,
        onDragEnd: onDragEnd,
        onResizeBegin: onResizeBegin,
        onResizeUpdate: onResizeUpdate,
        onResizeEnd: onResizeEnd,
      ),
    );
    expect(container.windowList.contains(window), true);
  }
  
  return container;
}

void main() {
  test('tests the WindowContainer\'s openWindow method', () {
    const numberOfWindows = 100;
    final container = getWindowContainerWithXOpenWindows(numberOfWindows);
    
    expect(container.windowList.length, numberOfWindows);
  });
  
  test('tests the WindowContainer\'s raiseWindow method', () {
    const numberOfWindows = 100;
    final container = getWindowContainerWithXOpenWindows(numberOfWindows);
    
    final random = Random(2603401855);
    Window getRandomWindow() {
      return container.windowList[random.nextInt(container.windowList.length)];
    }
    for (int i = 0; i < numberOfWindows * 2; i++) {
      final window = getRandomWindow();
      window.raise();
      expect(container.windowList.last.key, window.key);
    }
  });
  
  test('tests the WindowContainer\'s closeWindow method', () {
    const numberOfWindows = 100;
    final container = getWindowContainerWithXOpenWindows(numberOfWindows);
    
    final random = Random(3131333778);
    Window getRandomWindow() {
      return container.windowList[random.nextInt(container.windowList.length)];
    }
    for (int i = 0; i < numberOfWindows; i++) {
      final window = getRandomWindow();
      window.close();
      expect(container.windowList.length, numberOfWindows - (i + 1));
      expect(container.windowList.contains(window), false);
    }
  });
  
  test('tests the WindowContainer\'s closeAllWindows method', () {
    const numberOfWindows = 100;
    final container = getWindowContainerWithXOpenWindows(numberOfWindows);
    
    container.closeAllWindows();
    expect(container.windowList.isEmpty, true);
  });
  
  test('tests the Window\'s onRaise and onClose callbacks', () {
    final isRaisedMap = <Window, bool>{};
    final isClosedMap = <Window, bool>{};
    
    const numberOfWindows = 100;
    final container = getWindowContainerWithXOpenWindows(
      numberOfWindows,
      onClose: (window) => isClosedMap[window] = true,
      onRaise: (window) => isRaisedMap[window] = true,
    );
    
    for (Window window in container.windowList) {
      isRaisedMap[window] = false;
      isClosedMap[window] = false;
    }
    
    for (int i = 0; i < numberOfWindows; i++) {
      final window = container.windowList[0];
      window.raise();
      expect(isRaisedMap[window], true);
    }
    
    for (int i = 0; i < numberOfWindows; i++) {
      final window = container.windowList[0];
      window.close();
      expect(isRaisedMap[window], true);
    }
  });
}
