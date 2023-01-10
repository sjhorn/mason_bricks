import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:{{package}}/features/{{feature}}/{{feature}}.dart';

part '{{feature}}_read_event.dart';
part '{{feature}}_read_state.dart';

class {{feature.pascalCase()}}ReadBloc extends Bloc<{{feature.pascalCase()}}ReadEvent, {{feature.pascalCase()}}ReadState> {
  final {{feature.pascalCase()}}Repository _repo;
  {{feature.pascalCase()}}ReadBloc(this._repo) : super({{feature.pascalCase()}}ReadStateInitial()) {
    on<{{feature.pascalCase()}}ReadEventSubscribe>(_eventSubscribe);
    on<{{feature.pascalCase()}}ReadEventReload>(_eventReload);
    on<{{feature.pascalCase()}}ReadEventReadMore>(_eventReadMore);
    on<{{feature.pascalCase()}}ReadEventCreate>(_eventAdd);
    on<{{feature.pascalCase()}}ReadEventDelete>(_eventDelete);
    on<{{feature.pascalCase()}}ReadEventUpdate>(_eventUpdate);

    // Subscribe to reactive repo and then laod
    add(const {{feature.pascalCase()}}ReadEventSubscribe());
    add(const {{feature.pascalCase()}}ReadEventReload());
  }

  _eventSubscribe({{feature.pascalCase()}}ReadEventSubscribe event, Emitter<{{feature.pascalCase()}}ReadState> emit) async {
    await emit.forEach<{{feature.pascalCase()}}ChangeInfo>(
      _repo.read(),
      onData: (info) {
        switch (info.type) {
          
          case {{feature.pascalCase()}}ChangeType.create:
            return {{feature.pascalCase()}}ReadStateCreate(selected{{feature.pascalCase()}}: info.{{feature}}s.first);
          case {{feature.pascalCase()}}ChangeType.read:
            return {{feature.pascalCase()}}ReadStateSuccess(
              {{feature}}s: info.{{feature}}s,
              totalCount: info.totalCount,
            );
          case {{feature.pascalCase()}}ChangeType.update:
            return {{feature.pascalCase()}}ReadStateUpdate(selected{{feature.pascalCase()}}: info.{{feature}}s.first);
          case {{feature.pascalCase()}}ChangeType.delete:
            return {{feature.pascalCase()}}ReadStateDelete(selected{{feature.pascalCase()}}: info.{{feature}}s.first);
        }
      },
      onError: (error, stackTrace) => {{feature.pascalCase()}}ReadStateFailure(message: '$error'),
    );
  }

  _eventReload({{feature.pascalCase()}}ReadEventReload event, Emitter<{{feature.pascalCase()}}ReadState> emit) async {
    emit({{feature.pascalCase()}}ReadStateLoading());
    _repo.readMore(true);
  }

  _eventReadMore({{feature.pascalCase()}}ReadEventReadMore event, Emitter<{{feature.pascalCase()}}ReadState> emit) async {
    _repo.readMore();
  }

  _eventDelete({{feature.pascalCase()}}ReadEventDelete event, Emitter<{{feature.pascalCase()}}ReadState> emit) async {
    _repo.delete(event.{{feature}});
  }

  _eventUpdate({{feature.pascalCase()}}ReadEventUpdate event, Emitter<{{feature.pascalCase()}}ReadState> emit) async {
    _repo.update(event.{{feature}});
  }

  _eventAdd({{feature.pascalCase()}}ReadEventCreate event, Emitter<{{feature.pascalCase()}}ReadState> emit) {
    _repo.create({{feature.pascalCase()}}({{#properties}}{{name}}:{{{emptyValue}}},{{/properties}}));
  }
}
