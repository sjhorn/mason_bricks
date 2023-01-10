import 'dart:async';
import 'package:equatable/equatable.dart';

import 'package:scaffolding_sample/features/feature1/feature1.dart';

// CRUD Repo based on a stream
abstract class Feature1Repository {
  late Future ready;

  final _controller = StreamController<Feature1ChangeInfo>();
  Stream<Feature1ChangeInfo>? _stream;
  

  void addToStream(Feature1ChangeInfo changeInfo) =>
      _controller.sink.add(changeInfo);
  void addErrorToStream(Object error) => _controller.sink.addError(error);
  
  Future<void> create(Feature1 feature1);

  Stream<Feature1ChangeInfo> read() => _stream ??= _controller.stream.asBroadcastStream();

  Future<void> readMore([bool refresh = false]);
  
  Future<void> update(Feature1 feature1);

  Future<void> delete(Feature1 feature1);
}

enum Feature1ChangeType { create, read, update, delete }

class Feature1ChangeInfo extends Equatable {
  final Feature1ChangeType type;
  final List<Feature1> feature1s;
  final int totalCount;
  const Feature1ChangeInfo(
      {required this.type, required this.feature1s, this.totalCount = 0});

  @override
  List<Object?> get props => [type, feature1s, totalCount];
}