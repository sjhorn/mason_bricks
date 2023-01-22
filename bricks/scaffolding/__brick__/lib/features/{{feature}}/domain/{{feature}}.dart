import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class {{feature.pascalCase()}} extends Equatable {
  final String id;
  final DateTime created;
  final DateTime modified;
  {{#properties}}
  final {{type}} {{name}};{{/properties}}

  {{feature.pascalCase()}}({ 
    String? id,
    DateTime? created,
    DateTime? modified,{{#properties}}
    required this.{{name}},{{/properties}}
  }) : id = id ?? const Uuid().v4(),
       created = created ?? DateTime.now(),
       modified = modified ?? DateTime.now();

  @override
  List<Object> get props => [id, created, modified, {{#properties}} {{name}},{{/properties}} ];

  @override
  String toString() {
    return '{{feature.PascalCase()}}(id: $id, {{#properties}} {{name}}: ${{name}},{{/properties}} )';
  }

  {{feature.pascalCase()}} copyWith({ 
    String? id,
    DateTime? created,
    DateTime? modified,{{#properties}}
    {{type}}? {{name}},{{/properties}}
  }) {
    return {{feature.pascalCase()}}( 
      id: id ?? this.id,
      created: created ?? DateTime.now(),
      modified: modified ?? DateTime.now(),{{#properties}}
      {{name}} : {{name}} ?? this.{{name}},{{/properties}}
    );
  }
}