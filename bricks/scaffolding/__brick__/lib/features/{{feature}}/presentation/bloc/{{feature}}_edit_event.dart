part of '{{feature}}_edit_bloc.dart';

abstract class {{feature.pascalCase()}}EditEvent extends Equatable {
  const {{feature.pascalCase()}}EditEvent();
}
{{#properties}}
class {{feature.pascalCase()}}EditEvent{{name.pascalCase()}}Changed extends {{feature.pascalCase()}}EditEvent {
  final {{type}} {{name}};
  const {{feature.pascalCase()}}EditEvent{{name.pascalCase()}}Changed(this.{{name}},);

  @override
  List<Object?> get props => [{{name}}];
}
{{/properties}}
class {{feature.pascalCase()}}EditEventSubmitted extends {{feature.pascalCase()}}EditEvent {
  @override
  List<Object?> get props => [];
}

class {{feature.pascalCase()}}EditEventDelete extends {{feature.pascalCase()}}EditEvent {
  @override
  List<Object?> get props => [];
}