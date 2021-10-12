import 'dart:math';

// TODO: remove if unused
class ArduinoMap {
  static double map(double x, double inMin, double inMax, double outMin, double outMax) {
    return (x - inMin) * (outMax - outMin) / (inMax - inMin) + outMin;
  }
  
  static double constrainedMap(double x, double inMin, double inMax, double outMin, double outMax) {
    final result = map(x, inMin, inMax, outMin, outMax);
    
    if (outMin > outMax) {
      return min(outMin, max(outMax, result));
    }
    return min(outMax, max(outMin, result));
  }
}