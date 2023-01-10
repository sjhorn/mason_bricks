import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:{{package}}/features/{{feature}}/{{feature}}.dart';

class Mock{{feature.pascalCase()}}Repository extends Mock implements {{feature.pascalCase()}}Repository {}

class Test{{feature.pascalCase()}}Repo extends {{feature.pascalCase()}}Repository {
  @override
  Future<void> create({{feature.pascalCase()}} {{feature}}) {
    throw UnimplementedError();
  }

  @override
  Future<void> readMore([bool force = false]) {
    throw UnimplementedError();
  }

  @override
  Future<void> update({{feature.pascalCase()}} {{feature}}) {
    throw UnimplementedError();
  }
  @override
  Future<void> delete({{feature.pascalCase()}} {{feature}}) {
    throw UnimplementedError();
  }
}

void main() {
  late Mock{{feature.pascalCase()}}Repository mock{{feature.pascalCase()}}Repository;
  const id = 'test-{{feature}}-1';
  final test{{feature.pascalCase()}} = {{feature.pascalCase()}}(id: id, {{#properties}}{{name}}:{{{testValue}}},{{/properties}});
  
  final changeInfo =
      {{feature.pascalCase()}}ChangeInfo(type: {{feature.pascalCase()}}ChangeType.read, {{feature}}s: [test{{feature.pascalCase()}}]);
  setUp(() {
    mock{{feature.pascalCase()}}Repository = Mock{{feature.pascalCase()}}Repository();
  });
  group('{{feature.pascalCase()}} repo', () {

    test('get returns changeInfo from read', () async {
      when(() => mock{{feature.pascalCase()}}Repository.read())
          .thenAnswer((_) => Stream.value(changeInfo));
      var issues = mock{{feature.pascalCase()}}Repository.read();
      verify(() => mock{{feature.pascalCase()}}Repository.read()).called(1);
      expect(issues, emits(changeInfo));
    });
    test('check get returns error when error is added', () async {
      const error = 'test-error';
      final repo = Test{{feature.pascalCase()}}Repo();
      expectLater(repo.read(), emitsError(error));
      repo.addErrorToStream(error);
    });
     test('check get returns changeInfo when changeInfo is added', () async {
      final repo = Test{{feature.pascalCase()}}Repo();
      expectLater(repo.read(), emits(changeInfo));
      repo.addToStream(changeInfo);
    });
  });

  group('{{feature.pascalCase()}} entity', () {
    test('{{feature}} uuid as id works', () async {
      final uuidTest = {{feature.pascalCase()}}({{#properties}}{{name}}:{{{testValue}}},{{/properties}});
      expect(uuidTest.id, isNotEmpty);
    });
    test('{{feature}} toString works', () async {
      expect(test{{feature.pascalCase()}}.toString(), contains(test{{feature.pascalCase()}}.id));
    });
    test('{{feature}} copyWith works', () async {
      final copy = test{{feature.pascalCase()}}.copyWith(id: 'test-copy');
      expect(test{{feature.pascalCase()}}.id, equals(id));
      expect(copy.id, equals('test-copy'));

      final copy2 = test{{feature.pascalCase()}}.copyWith();
      expect(copy2.id, test{{feature.pascalCase()}}.id);
    });
  });
}
