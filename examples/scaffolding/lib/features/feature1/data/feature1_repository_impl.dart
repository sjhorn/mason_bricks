import 'dart:async';
import 'package:scaffolding_sample/features/feature1/feature1.dart';

class Feature1RepositoryImpl extends Feature1Repository {

  final Map<String, Feature1Model> _store = {};

  @override
  Future<void> create(Feature1 feature1) async {
    _store[feature1.id] = Feature1Model.fromFeature1(feature1);
    addToStream(Feature1ChangeInfo(type: Feature1ChangeType.create, feature1s: [feature1]));
  }

   @override
  Future<void> readMore([bool refresh = true]) async {
    await _getFeature1sFromStore();
  }

  @override
  Future<void> update(Feature1 feature1) async {
    _store[feature1.id] = Feature1Model.fromFeature1(feature1);
    addToStream(Feature1ChangeInfo(type: Feature1ChangeType.update, feature1s: [feature1]));
  }

  @override
  Future<void> delete(Feature1 feature1) async {
    _store.remove(feature1.id);
    addToStream(Feature1ChangeInfo(type: Feature1ChangeType.delete, feature1s: [feature1]));
  }

  Future<void> _getFeature1sFromStore() async {
    List<Feature1> feature1List = _store.entries
        .map((e) => e.value.toFeature1())
        .toList();
    addToStream(Feature1ChangeInfo(
        type: Feature1ChangeType.read,
        feature1s: feature1List,
        totalCount: feature1List.length));
  }
}

