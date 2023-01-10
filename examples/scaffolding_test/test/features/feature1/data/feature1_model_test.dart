import 'package:flutter_test/flutter_test.dart';

import 'package:scaffolding_sample/features/feature1/feature1.dart';

void main() async {
  const id = 'test-feature1-1';
  late Feature1 testEntity;
  late Feature1Model testModel;

  setUp(() async {
    testEntity = Feature1(
      id: id, 
      firstName: 'testString',
      lastName: 'testString',
      registered: true,
      age: 1,
    );
    testModel = Feature1Model(
      id: id, 
      created: testEntity.created, 
      modified: testEntity.modified, 
      firstName: 'testString',
      lastName: 'testString',
      registered: true,
      age: 1,
    );
  });

  group('Test Model commutative features', () {
    test('toFeature1', () {
      expect(testModel.toFeature1(), equals(testEntity));
    });
    test('fromFeature1', () {
      expect(Feature1Model.fromFeature1(testEntity), equals(testModel));
    });
    test('fromMap', () {
      expect(Feature1Model.fromMap(testModel.toMap()), equals(testModel)); 
    });
    test('toJson', () {
      expect(Feature1Model.fromJson(testModel.toJson()), equals(testModel));
    });
  });
}
