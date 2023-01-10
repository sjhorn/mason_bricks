import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:scaffolding_sample/features/feature1/feature1.dart';

class MockFeature1Repository extends Mock implements Feature1Repository {}

class TestFeature1Repo extends Feature1Repository {
  @override
  Future<void> create(Feature1 feature1) {
    throw UnimplementedError();
  }

  @override
  Future<void> readMore([bool force = false]) {
    throw UnimplementedError();
  }

  @override
  Future<void> update(Feature1 feature1) {
    throw UnimplementedError();
  }
  @override
  Future<void> delete(Feature1 feature1) {
    throw UnimplementedError();
  }
}

void main() {
  late MockFeature1Repository mockFeature1Repository;
  const id = 'test-feature1-1';
  final testFeature1 = Feature1(id: id, firstName:'testString',lastName:'testString',registered:true,age:1,);
  
  final changeInfo =
      Feature1ChangeInfo(type: Feature1ChangeType.read, feature1s: [testFeature1]);
  setUp(() {
    mockFeature1Repository = MockFeature1Repository();
  });
  group('Feature1 repo', () {

    test('get returns changeInfo from read', () async {
      when(() => mockFeature1Repository.read())
          .thenAnswer((_) => Stream.value(changeInfo));
      var issues = mockFeature1Repository.read();
      verify(() => mockFeature1Repository.read()).called(1);
      expect(issues, emits(changeInfo));
    });
    test('check get returns error when error is added', () async {
      const error = 'test-error';
      final repo = TestFeature1Repo();
      expectLater(repo.read(), emitsError(error));
      repo.addErrorToStream(error);
    });
     test('check get returns changeInfo when changeInfo is added', () async {
      final repo = TestFeature1Repo();
      expectLater(repo.read(), emits(changeInfo));
      repo.addToStream(changeInfo);
    });
  });

  group('Feature1 entity', () {
    test('feature1 uuid as id works', () async {
      final uuidTest = Feature1(firstName:'testString',lastName:'testString',registered:true,age:1,);
      expect(uuidTest.id, isNotEmpty);
    });
    test('feature1 toString works', () async {
      expect(testFeature1.toString(), contains(testFeature1.id));
    });
    test('feature1 copyWith works', () async {
      final copy = testFeature1.copyWith(id: 'test-copy');
      expect(testFeature1.id, equals(id));
      expect(copy.id, equals('test-copy'));

      final copy2 = testFeature1.copyWith();
      expect(copy2.id, testFeature1.id);
    });
  });
}
