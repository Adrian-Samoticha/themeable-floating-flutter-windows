import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:themeable_floating_windows/window_container/window_properties.dart';

import 'animation_properties.dart';
import 'window.dart';

class WindowContainer {
  final List<Window> _windowList = [];
  
  /// Gets the window container's window list.
  /// 
  /// Warning: This list should not be edited.
  List<Window> get windowList => _windowList;
  
  /// Adds the [window] to the end of the [_windowList].
  void _addWindowToEndOfWindowList(Window window) {
    _windowList.add(window);
  }
  
  /// Removes the [window] from the [_windowList].
  bool _removeWindowFromWindowList(Window window) {
    return _windowList.remove(window);
  }
  
  /// Opens a new window with the given [properties].
  Window openWindow(WindowProperties properties) {
    final window = Window(UniqueKey(), this, properties);
    _addWindowToEndOfWindowList(window);
    return window;
  }
  
  /// Closes the [window].
  bool closeWindow(Window window) {
    window.triggerOnCloseCallback();
    
    return _removeWindowFromWindowList(window);
  }
  
  /// Closes all windows.
  void closeAllWindows() {
    while (_windowList.isNotEmpty) {
      closeWindow(_windowList[_windowList.length - 1]);
    }
  }
  
  /// Raises the [window].
  void raiseWindow(Window window) {
    _removeWindowFromWindowList(window);
    _addWindowToEndOfWindowList(window);
    
    window.triggerOnRaiseCallback();
  }
  
  /// Moves the [window].
  void moveWindow(Window window, Offset relativeAmount, AnimationProperties animationProperties) {
    window.positionChangeAnimationProperties = animationProperties;
    
    window.properties.position.left += relativeAmount.dx;
    window.properties.position.top += relativeAmount.dy;
    
    window.triggerOnPositionChangedCallback();
  }
  
  /// Moves the [window] to a given position.
  void moveWindowTo(Window window, Offset position, AnimationProperties animationProperties) {
    window.positionChangeAnimationProperties = animationProperties;
    
    window.properties.position.left = position.dx;
    window.properties.position.top = position.dy;
    
    window.triggerOnPositionChangedCallback();
  }
  
  /// Resizes the [window].
  /// 
  /// If the final size of the window were to be smaller than [minSize]
  /// the size will be capped at [minSize].
  /// Returns the actual amount by which the window has been resized.
  Offset resizeWindow(Window window, Offset relativeAmount, AnimationProperties animationProperties) {
    window.positionChangeAnimationProperties = animationProperties;
    
     final oldSize = Offset(
      window.properties.position.width,
      window.properties.position.height
    );
    
    window.properties.position.width = max(
      window.properties.minSize.width,
      window.properties.position.width + relativeAmount.dx
    );
    window.properties.position.height = max(
      window.properties.minSize.height,
      window.properties.position.height + relativeAmount.dy
    );
    
    final newSize = Offset(
      window.properties.position.width,
      window.properties.position.height
    );
    
    window.triggerOnPositionChangedCallback();
    
    return newSize - oldSize;
  }
  
  /// Maximizes a window.
  void maximizeWindow(Window window, AnimationProperties animationProperties) {
    window.positionChangeAnimationProperties = animationProperties;
    
    window.properties.isMaximized = true;
    
    window.triggerOnMaximizeCallback();
  }
  
  /// Restores a window.
  void restoreWindow(Window window, AnimationProperties animationProperties) {
    window.positionChangeAnimationProperties = animationProperties;
    
    window.properties.isMaximized = false;
    
    window.triggerOnRestoreCallback();
  }
}