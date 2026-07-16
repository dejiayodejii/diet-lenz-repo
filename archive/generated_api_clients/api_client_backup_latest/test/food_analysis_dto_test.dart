//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

import 'package:openapi/api.dart';
import 'package:test/test.dart';

// tests for FoodAnalysisDto
void main() {
  // final instance = FoodAnalysisDto();

  group('test FoodAnalysisDto', () {
    // String foodName
    test('to test the property `foodName`', () async {
      // TODO
    });

    // String description
    test('to test the property `description`', () async {
      // TODO
    });

    // MacroNutrientsDto totalMacros
    test('to test the property `totalMacros`', () async {
      // TODO
    });

    // String imageBase64
    test('to test the property `imageBase64`', () async {
      // TODO
    });

    test('deserializes measures from the backend response', () {
      final result = FoodAnalysisDto.fromJson({
        'foodName': 'Rice Cooked',
        'measures': [
          {'label': 'Serving', 'weightGrams': 200.0},
          {'label': 'Gram', 'weightGrams': 1.0},
        ],
      });

      expect(result, isNotNull);
      expect(result!.measures, hasLength(2));
      expect(result.measures.first.label, 'Serving');
      expect(result.measures.first.weightGrams, 200.0);
      expect(result.measures.last.label, 'Gram');
      expect(result.toJson()['measures'], result.measures);
    });
  });
}
