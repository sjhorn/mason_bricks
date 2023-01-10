import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:scaffolding_sample/features/feature1/feature1.dart';

part 'feature1_read_event.dart';
part 'feature1_read_state.dart';

class Feature1ReadBloc extends Bloc<Feature1ReadEvent, Feature1ReadState> {
  final Feature1Repository _repo;
  Feature1ReadBloc(this._repo) : super(Feature1ReadStateInitial()) {
    on<Feature1ReadEventSubscribe>(_eventSubscribe);
    on<Feature1ReadEventReload>(_eventReload);
    on<Feature1ReadEventReadMore>(_eventReadMore);
    on<Feature1ReadEventCreate>(_eventAdd);
    on<Feature1ReadEventDelete>(_eventDelete);
    on<Feature1ReadEventUpdate>(_eventUpdate);

    // Subscribe to reactive repo and then laod
    add(const Feature1ReadEventSubscribe());
    add(const Feature1ReadEventReload());
  }

  _eventSubscribe(Feature1ReadEventSubscribe event, Emitter<Feature1ReadState> emit) async {
    await emit.forEach<Feature1ChangeInfo>(
      _repo.read(),
      onData: (info) {
        switch (info.type) {
          
          case Feature1ChangeType.create:
            return Feature1ReadStateCreate(selectedFeature1: info.feature1s.first);
          case Feature1ChangeType.read:
            return Feature1ReadStateSuccess(
              feature1s: info.feature1s,
              totalCount: info.totalCount,
            );
          case Feature1ChangeType.update:
            return Feature1ReadStateUpdate(selectedFeature1: info.feature1s.first);
          case Feature1ChangeType.delete:
            return Feature1ReadStateDelete(selectedFeature1: info.feature1s.first);
        }
      },
      onError: (error, stackTrace) => Feature1ReadStateFailure(message: '$error'),
    );
  }

  _eventReload(Feature1ReadEventReload event, Emitter<Feature1ReadState> emit) async {
    emit(Feature1ReadStateLoading());
    _repo.readMore(true);
  }

  _eventReadMore(Feature1ReadEventReadMore event, Emitter<Feature1ReadState> emit) async {
    _repo.readMore();
  }

  _eventDelete(Feature1ReadEventDelete event, Emitter<Feature1ReadState> emit) async {
    _repo.delete(event.feature1);
  }

  _eventUpdate(Feature1ReadEventUpdate event, Emitter<Feature1ReadState> emit) async {
    _repo.update(event.feature1);
  }

  _eventAdd(Feature1ReadEventCreate event, Emitter<Feature1ReadState> emit) {
    _repo.create(Feature1(firstName:'',lastName:'',registered:false,age:0,));
  }
}
