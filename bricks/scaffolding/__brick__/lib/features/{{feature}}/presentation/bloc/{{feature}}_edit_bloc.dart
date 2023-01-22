import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:{{package}}/features/{{feature}}/{{feature}}.dart';

part '{{feature}}_edit_event.dart';
part '{{feature}}_edit_state.dart';

class {{feature.pascalCase()}}EditBloc extends Bloc<{{feature.pascalCase()}}EditEvent, {{feature.pascalCase()}}EditState> {
  final {{feature.pascalCase()}}Repository _repo;
  {{feature.pascalCase()}}EditBloc(this._repo, [{{feature.pascalCase()}}? entity])
      : super({{feature.pascalCase()}}EditState(
          {{feature}}: entity, {{#properties}}
          {{name}}: entity?.{{name}} ?? {{{defaultValue}}},{{/properties}}
        )) {
    {{#properties}}on<{{feature.pascalCase()}}EditEvent{{name.pascalCase()}}Changed>(_{{name}}Changed);
    {{/properties}}on<{{feature.pascalCase()}}EditEventSubmitted>(_submitted);
    on<{{feature.pascalCase()}}EditEventDelete>(_delete);
  }
  {{#properties}}  
  FutureOr<void> _{{name}}Changed(
      {{feature.pascalCase()}}EditEvent{{name.pascalCase()}}Changed event, Emitter<{{feature.pascalCase()}}EditState> emit) async {
    emit(state.copyWith({{name}}: event.{{name}}));
  } {{/properties}}


  FutureOr<void> _submitted(
      {{feature.pascalCase()}}EditEventSubmitted event, Emitter<{{feature.pascalCase()}}EditState> emit) async {
    {{feature.pascalCase()}} entity;
    if (state.{{feature}} == null) {
      entity = {{feature.pascalCase()}}({{#properties}}{{name}}: state.{{name}},{{/properties}});
      await _repo.create(entity);
    } else {
      entity = state.{{feature}}!.copyWith({{#properties}}
        {{name}}: state.{{name}},{{/properties}}
      );
      await _repo.update(entity);
    }
    emit(state.copyWith(initial{{feature.pascalCase()}}: entity, status: {{feature.pascalCase()}}EditStatus.success));
  }

  FutureOr<void> _delete(
      {{feature.pascalCase()}}EditEventDelete event, Emitter<{{feature.pascalCase()}}EditState> emit) async {
    await _repo.delete(state.{{feature}}!);
    emit(state.copyWith(initial{{feature.pascalCase()}}: state.{{feature}}!, status: {{feature.pascalCase()}}EditStatus.success));
  }
}
