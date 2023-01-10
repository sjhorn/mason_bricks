part of '{{feature}}_edit_bloc.dart';

enum {{feature.pascalCase()}}EditStatus { initial, loading, success, failure }

class {{feature.pascalCase()}}EditState extends Equatable {
  final {{feature.pascalCase()}}EditStatus status;
  final {{feature.pascalCase()}}? {{feature}};{{#properties}}
  final {{type}} {{name}};{{/properties}}
  
  const {{feature.pascalCase()}}EditState({
    this.status = {{feature.pascalCase()}}EditStatus.initial,
    this.{{feature}}, {{#properties}}
    required this.{{name}},{{/properties}}
  });

  @override
  List<Object?> get props => [status, {{feature}}, {{#properties}}{{name}}, {{/properties}}];

  {{feature.pascalCase()}}EditState copyWith({
    {{feature.pascalCase()}}EditStatus? status, 
    {{feature.pascalCase()}}? initial{{feature.pascalCase()}},{{#properties}}
    {{type}}? {{name}}, {{/properties}}
  }) {
    return {{feature.pascalCase()}}EditState(
      status: status ?? this.status,
      {{feature}}: initial{{feature.pascalCase()}} ?? {{feature}}, {{#properties}}
      {{name}}: {{name}} ?? this.{{name}},{{/properties}}
    );
  }
}
