import 'dart:math';

import 'package:affine/affine.dart';
import 'package:vector_math/vector_math.dart';

void main() {
  final rect = Rectangle(0.0, 0.0, 100.0, 100.0);

  final points = [
    Vector2Tuple(Vector2(rect.left, rect.top), Vector2(0, 0)),
    Vector2Tuple(Vector2(rect.right, rect.top), Vector2(150, 50)),
    Vector2Tuple(Vector2(rect.left, rect.bottom), Vector2(0, 100)),
    Vector2Tuple(Vector2(rect.right, rect.bottom), Vector2(100, 100)),
  ];

  final matrix = affineFromPoints2D(points)!;

  print(matrix);
}
