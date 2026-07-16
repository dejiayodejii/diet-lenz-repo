//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

import 'package:openapi/api.dart';
import 'package:test/test.dart';

void main() {
  group('test MeasureDto', () {
    test('deserializes label and weightGrams', () {
      final result = MeasureDto.fromJson({
        'label': 'Ounce',
        'weightGrams': 28.349523125,
      });

      expect(result, isNotNull);
      expect(result!.label, 'Ounce');
      expect(result.weightGrams, 28.349523125);
    });
  });
}
