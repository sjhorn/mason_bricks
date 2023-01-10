import 'package:flutter_test/flutter_test.dart';

import 'package:{{package}}/features/{{feature}}/{{feature}}.dart';

void main() async {
  const id = 'test-{{feature}}-1';
  late {{feature.pascalCase()}} testEntity;
  late {{feature.pascalCase()}}Model testModel;

  setUp(() async {
    testEntity = {{feature.pascalCase()}}(
      id: id, {{#properties}}
      {{name}}: {{{testValue}}},{{/properties}}
    );
    testModel = {{feature.pascalCase()}}Model(
      id: id, 
      created: testEntity.created, 
      modified: testEntity.modified, {{#properties}}
      {{name}}: {{{testValue}}},{{/properties}}
    );
  });

  group('Test Model commutative features', () {
    test('to{{feature.pascalCase()}}', () {
      expect(testModel.to{{feature.pascalCase()}}(), equals(testEntity));
    });
    test('from{{feature.pascalCase()}}', () {
      expect({{feature.pascalCase()}}Model.from{{feature.pascalCase()}}(testEntity), equals(testModel));
    });
    test('fromMap', () {
      expect({{feature.pascalCase()}}Model.fromMap(testModel.toMap()), equals(testModel)); 
    });
    test('toJson', () {
      expect({{feature.pascalCase()}}Model.fromJson(testModel.toJson()), equals(testModel));
    });
  });
}
