import 'dart:async';
import 'package:equatable/equatable.dart';

import 'package:{{package}}/features/{{feature}}/{{feature}}.dart';

// CRUD Repo based on a stream
abstract class {{feature.pascalCase()}}Repository {
  late Future ready;

  final _controller = StreamController<{{feature.pascalCase()}}ChangeInfo>();
  Stream<{{feature.pascalCase()}}ChangeInfo>? _stream;
  

  void addToStream({{feature.pascalCase()}}ChangeInfo changeInfo) =>
      _controller.sink.add(changeInfo);
  void addErrorToStream(Object error) => _controller.sink.addError(error);
  
  Future<void> create({{feature.pascalCase()}} {{feature}});

  Stream<{{feature.pascalCase()}}ChangeInfo> read() => _stream ??= _controller.stream.asBroadcastStream();

  Future<void> readMore([bool refresh = false]);
  
  Future<void> update({{feature.pascalCase()}} {{feature}});

  Future<void> delete({{feature.pascalCase()}} {{feature}});
}

enum {{feature.pascalCase()}}ChangeType { create, read, update, delete }

class {{feature.pascalCase()}}ChangeInfo extends Equatable {
  final {{feature.pascalCase()}}ChangeType type;
  final List<{{feature.pascalCase()}}> {{feature}}s;
  final int totalCount;
  const {{feature.pascalCase()}}ChangeInfo(
      {required this.type, required this.{{feature}}s, this.totalCount = 0});

  @override
  List<Object?> get props => [type, {{feature}}s, totalCount];
}