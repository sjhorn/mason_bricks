import 'package:flutter_test/flutter_test.dart';

import 'package:scaffolding_sample/features/feature1/feature1.dart';


void main() async {
  late Feature1RepositoryImpl repo;
  const id = 'test-feature1-1';
  final testFeature1Model = Feature1Model(id: id, firstName:'testString',lastName:'testString',registered:true,age:1,);

  setUp(() async {
     repo = Feature1RepositoryImpl();
  });

  group('Test CRUD on repo', () {
    test('create and read', () async {
        expectLater(
          repo.read(),
          emits(
            Feature1ChangeInfo(type: Feature1ChangeType.create, feature1s:[testFeature1Model.toFeature1()]),
          )
        );
        repo.create(testFeature1Model.toFeature1());
    });
    test('create and delete', () async {
        expectLater(
        repo.read(),
        emitsInOrder([
          Feature1ChangeInfo(type: Feature1ChangeType.create, feature1s: [testFeature1Model.toFeature1()]),
          Feature1ChangeInfo(type: Feature1ChangeType.delete, feature1s: [testFeature1Model.toFeature1()]),
        ]),
      );
      repo.create(testFeature1Model.toFeature1());
      repo.delete(testFeature1Model.toFeature1());
    });
    test('readMore', () async {
      repo.create(testFeature1Model.toFeature1());
      expectLater(
        repo.read(),
        emitsInOrder([
          Feature1ChangeInfo(
              type: Feature1ChangeType.create,
              feature1s: [testFeature1Model.toFeature1()]),
          Feature1ChangeInfo(
              type: Feature1ChangeType.read,
              totalCount: 1,
              feature1s: [testFeature1Model.toFeature1()]),
        ]),
      );
      repo.readMore(false);
    });
    test('readMore refresh', () async {
      repo.create(testFeature1Model.toFeature1());
      expectLater(
        repo.read(),
        emitsInOrder([
          Feature1ChangeInfo(
              type: Feature1ChangeType.create,
              feature1s: [testFeature1Model.toFeature1()]),
          Feature1ChangeInfo(
              type: Feature1ChangeType.read,
              totalCount: 1,
              feature1s: [testFeature1Model.toFeature1()]),
        ]),
      );
      repo.readMore();
    });
    test('create update', () async {
      final updateTest = testFeature1Model.toFeature1().copyWith(id: 'change-id');
      expectLater(
        repo.read(),
        emitsInOrder([
          Feature1ChangeInfo(
              type: Feature1ChangeType.create,
              feature1s: [testFeature1Model.toFeature1()]),
          Feature1ChangeInfo(
              type: Feature1ChangeType.update, feature1s: [updateTest]),
        ]),
      );
      repo.create(testFeature1Model.toFeature1());
      repo.update(updateTest);
    });
  });
}