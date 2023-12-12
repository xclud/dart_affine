import 'dart:math';

import 'package:affine/affine.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math.dart';

void main() {
  group('2D', () {
    final rect = Rectangle(0.0, 0.0, 100.0, 100.0);

    final points = [
      Vector2Tuple(Vector2(rect.left, rect.top), Vector2(0, 0)),
      Vector2Tuple(Vector2(rect.right, rect.top), Vector2(150, 50)),
      Vector2Tuple(Vector2(rect.left, rect.bottom), Vector2(0, 100)),
      Vector2Tuple(Vector2(rect.right, rect.bottom), Vector2(100, 100)),
    ];

    final matrix = affineFromPoints2D(points)!;

    test('Rect Test', () {
      expect(matrix[0], 13);
      expect(matrix[1], 1.25);
      expect(matrix[2], -0.25);
      expect(matrix[3], 13);
      expect(matrix[4], 0.25);
      expect(matrix[5], 0.75);
    });
  });
}
