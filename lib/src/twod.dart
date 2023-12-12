part of '../affine.dart';

class Vector2Tuple {
  const Vector2Tuple(this.a, this.b);

  final Vector2 a;
  final Vector2 b;
}

/// Construct the least squares best fit affine transformation matrix from a set of ground control points.
///
/// [points] Three or more ground control points having .a.x , .a.y and .b.x and .b.y.
///
/// Returns Affine transformation matrix elements.
/// [0] is x offset.
/// [1] is x scale.
/// [2] is x rotation.
/// [3] is y offset.
/// [4] is y rotation.
/// [5] is y scale.
List<double>? affineFromPoints2D(List<Vector2Tuple> points) {
  var sumX = 0.0, sumY = 0.0, sumXy = 0.0, sumXx = 0.0, sumYy = 0.0;
  var sumLon = 0.0, sumLonx = 0.0, sumLony = 0.0;
  var sumLat = 0.0, sumLatx = 0.0, sumLaty = 0.0;

  final affine = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0];

  if (points.length < 3) {
    return null;
  }

  for (var p in points) {
    sumX += p.a.x;
    sumY += p.a.y;
    sumXy += p.a.x * p.a.y;
    sumXx += p.a.x * p.a.x;
    sumYy += p.a.y * p.a.y;
    sumLon += p.b.x;
    sumLonx += p.b.x * p.a.x;
    sumLony += p.b.x * p.a.y;
    sumLat += p.b.y;
    sumLatx += p.b.y * p.a.x;
    sumLaty += p.b.y * p.a.y;
  }

  final divisor = points.length * (sumXx * sumYy - sumXy * sumXy) +
      2 * sumX * sumY * sumXy -
      sumY * sumY * sumXx -
      sumX * sumX * sumYy;

  /* -------------------------------------------------------------------- */
  /*      If the divisor is zero, there is no valid solution.             */
  /* -------------------------------------------------------------------- */
  if (divisor == 0) {
    return null;
  }

  /* -------------------------------------------------------------------- */
  /*      Compute top/left origin.                                        */
  /* -------------------------------------------------------------------- */

  affine[0] = (sumLon * (sumXx * sumYy - sumXy * sumXy) +
          sumLonx * (sumY * sumXy - sumX * sumYy) +
          sumLony * (sumX * sumXy - sumY * sumXx)) /
      divisor;

  affine[3] = (sumLat * (sumXx * sumYy - sumXy * sumXy) +
          sumLatx * (sumY * sumXy - sumX * sumYy) +
          sumLaty * (sumX * sumXy - sumY * sumXx)) /
      divisor;

  /* -------------------------------------------------------------------- */
  /*      Compute X related coefficients.                                 */
  /* -------------------------------------------------------------------- */
  affine[1] = (sumLon * (sumY * sumXy - sumX * sumYy) +
          sumLonx * (points.length * sumYy - sumY * sumY) +
          sumLony * (sumX * sumY - sumXy * points.length)) /
      divisor;

  affine[2] = (sumLon * (sumX * sumXy - sumY * sumXx) +
          sumLonx * (sumX * sumY - points.length * sumXy) +
          sumLony * (points.length * sumXx - sumX * sumX)) /
      divisor;

  /* -------------------------------------------------------------------- */
  /*      Compute Y related coefficients.                                 */
  /* -------------------------------------------------------------------- */
  affine[4] = (sumLat * (sumY * sumXy - sumX * sumYy) +
          sumLatx * (points.length * sumYy - sumY * sumY) +
          sumLaty * (sumX * sumY - sumXy * points.length)) /
      divisor;

  affine[5] = (sumLat * (sumX * sumXy - sumY * sumXx) +
          sumLatx * (sumX * sumY - points.length * sumXy) +
          sumLaty * (points.length * sumXx - sumX * sumX)) /
      divisor;

  affine[0] += 0.5 * affine[1] + 0.5 * affine[2];
  affine[3] += 0.5 * affine[4] + 0.5 * affine[5];

  return affine;
}
