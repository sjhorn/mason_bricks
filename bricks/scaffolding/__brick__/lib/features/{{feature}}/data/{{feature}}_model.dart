import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import 'package:{{package}}/features/{{feature}}/{{feature}}.dart';

class {{feature.pascalCase()}}Model extends Equatable {
  final String id;
  final DateTime created;
  final DateTime modified;
  {{#properties}}final {{type}} {{name}};
  {{/properties}}
  {{feature.pascalCase()}}Model({ 
    String? id,
    DateTime? created,
    DateTime? modified,{{#properties}}
    required this.{{name}},{{/properties}}    
  }) : id = id ?? const Uuid().v4(),
       created = created ?? DateTime.now(),
       modified = modified ?? DateTime.now();

  {{feature.pascalCase()}} to{{feature.pascalCase()}}() {
    return {{feature.pascalCase()}}( 
      id: id, 
      created: created, 
      modified: modified, {{#properties}}
      {{name}}: {{name}},{{/properties}}    
    );
  }

  static {{feature.pascalCase()}}Model from{{feature.pascalCase()}}({{feature.pascalCase()}} {{feature}}) {
    return {{feature.pascalCase()}}Model( 
      id: {{feature}}.id, 
      created: {{feature}}.created, 
      modified: {{feature}}.modified, {{#properties}}
      {{name}}: {{feature}}.{{name}},{{/properties}} 
    );
  }

  Map<String, dynamic> toMap() {
    return { {{#properties}}
     '{{name}}': {{name}},{{/properties}} 
    };
  }

  factory {{feature.pascalCase()}}Model.fromMap(Map<String, dynamic> map) {
    return {{feature.pascalCase()}}Model({{#properties}}
     {{name}}: map['{{name}}'],{{/properties}} 
    );
  }

  String toJson() => json.encode(toMap());

  factory {{feature.pascalCase()}}Model.fromJson(String source) =>
    {{feature.pascalCase()}}Model.fromMap(json.decode(source));

  @override
  List<Object> get props => [{{#properties}} {{name}},{{/properties}} ];

}