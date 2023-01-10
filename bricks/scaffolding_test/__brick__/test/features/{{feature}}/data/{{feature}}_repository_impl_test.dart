import 'package:flutter_test/flutter_test.dart';

import 'package:{{package}}/features/{{feature}}/{{feature}}.dart';


void main() async {
  late {{feature.pascalCase()}}RepositoryImpl repo;
  const id = 'test-{{feature}}-1';
  final test{{feature.pascalCase()}}Model = {{feature.pascalCase()}}Model(id: id, {{#properties}}{{name}}:{{{testValue}}},{{/properties}});

  setUp(() async {
     repo = {{feature.pascalCase()}}RepositoryImpl();
  });

  group('Test CRUD on repo', () {
    test('create and read', () async {
        expectLater(
          repo.read(),
          emits(
            {{feature.pascalCase()}}ChangeInfo(type: {{feature.pascalCase()}}ChangeType.create, {{feature}}s:[test{{feature.pascalCase()}}Model.to{{feature.pascalCase()}}()]),
          )
        );
        repo.create(test{{feature.pascalCase()}}Model.to{{feature.pascalCase()}}());
    });
    test('create and delete', () async {
        expectLater(
        repo.read(),
        emitsInOrder([
          {{feature.pascalCase()}}ChangeInfo(type: {{feature.pascalCase()}}ChangeType.create, {{feature}}s: [test{{feature.pascalCase()}}Model.to{{feature.pascalCase()}}()]),
          {{feature.pascalCase()}}ChangeInfo(type: {{feature.pascalCase()}}ChangeType.delete, {{feature}}s: [test{{feature.pascalCase()}}Model.to{{feature.pascalCase()}}()]),
        ]),
      );
      repo.create(test{{feature.pascalCase()}}Model.to{{feature.pascalCase()}}());
      repo.delete(test{{feature.pascalCase()}}Model.to{{feature.pascalCase()}}());
    });
    test('readMore', () async {
      repo.create(test{{feature.pascalCase()}}Model.to{{feature.pascalCase()}}());
      expectLater(
        repo.read(),
        emitsInOrder([
          {{feature.pascalCase()}}ChangeInfo(
              type: {{feature.pascalCase()}}ChangeType.create,
              {{feature}}s: [test{{feature.pascalCase()}}Model.to{{feature.pascalCase()}}()]),
          {{feature.pascalCase()}}ChangeInfo(
              type: {{feature.pascalCase()}}ChangeType.read,
              totalCount: 1,
              {{feature}}s: [test{{feature.pascalCase()}}Model.to{{feature.pascalCase()}}()]),
        ]),
      );
      repo.readMore(false);
    });
    test('readMore refresh', () async {
      repo.create(test{{feature.pascalCase()}}Model.to{{feature.pascalCase()}}());
      expectLater(
        repo.read(),
        emitsInOrder([
          {{feature.pascalCase()}}ChangeInfo(
              type: {{feature.pascalCase()}}ChangeType.create,
              {{feature}}s: [test{{feature.pascalCase()}}Model.to{{feature.pascalCase()}}()]),
          {{feature.pascalCase()}}ChangeInfo(
              type: {{feature.pascalCase()}}ChangeType.read,
              totalCount: 1,
              {{feature}}s: [test{{feature.pascalCase()}}Model.to{{feature.pascalCase()}}()]),
        ]),
      );
      repo.readMore();
    });
    test('create update', () async {
      final updateTest = test{{feature.pascalCase()}}Model.to{{feature.pascalCase()}}().copyWith(id: 'change-id');
      expectLater(
        repo.read(),
        emitsInOrder([
          {{feature.pascalCase()}}ChangeInfo(
              type: {{feature.pascalCase()}}ChangeType.create,
              {{feature}}s: [test{{feature.pascalCase()}}Model.to{{feature.pascalCase()}}()]),
          {{feature.pascalCase()}}ChangeInfo(
              type: {{feature.pascalCase()}}ChangeType.update, {{feature}}s: [updateTest]),
        ]),
      );
      repo.create(test{{feature.pascalCase()}}Model.to{{feature.pascalCase()}}());
      repo.update(updateTest);
    });
  });
}