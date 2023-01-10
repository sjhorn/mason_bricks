import 'dart:async';
import 'package:{{package}}/features/{{feature}}/{{feature}}.dart';

class {{feature.pascalCase()}}RepositoryImpl extends {{feature.pascalCase()}}Repository {

  final Map<String, {{feature.pascalCase()}}Model> _store = {};

  @override
  Future<void> create({{feature.pascalCase()}} {{feature}}) async {
    _store[{{feature}}.id] = {{feature.pascalCase()}}Model.from{{feature.pascalCase()}}({{feature}});
    addToStream({{feature.pascalCase()}}ChangeInfo(type: {{feature.pascalCase()}}ChangeType.create, {{feature}}s: [{{feature}}]));
  }

   @override
  Future<void> readMore([bool refresh = true]) async {
    await _get{{feature.pascalCase()}}sFromStore();
  }

  @override
  Future<void> update({{feature.pascalCase()}} {{feature}}) async {
    _store[{{feature}}.id] = {{feature.pascalCase()}}Model.from{{feature.pascalCase()}}({{feature}});
    addToStream({{feature.pascalCase()}}ChangeInfo(type: {{feature.pascalCase()}}ChangeType.update, {{feature}}s: [{{feature}}]));
  }

  @override
  Future<void> delete({{feature.pascalCase()}} {{feature}}) async {
    _store.remove({{feature}}.id);
    addToStream({{feature.pascalCase()}}ChangeInfo(type: {{feature.pascalCase()}}ChangeType.delete, {{feature}}s: [{{feature}}]));
  }

  Future<void> _get{{feature.pascalCase()}}sFromStore() async {
    List<{{feature.pascalCase()}}> {{feature}}List = _store.entries
        .map((e) => e.value.to{{feature.pascalCase()}}())
        .toList();
    addToStream({{feature.pascalCase()}}ChangeInfo(
        type: {{feature.pascalCase()}}ChangeType.read,
        {{feature}}s: {{feature}}List,
        totalCount: {{feature}}List.length));
  }
}

