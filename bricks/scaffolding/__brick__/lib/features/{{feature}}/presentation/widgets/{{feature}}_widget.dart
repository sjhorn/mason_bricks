import 'package:flutter/material.dart';

import 'package:{{package}}/features/{{feature}}/{{feature}}.dart';

class {{feature.pascalCase()}}Widget extends StatelessWidget {
  final {{feature.pascalCase()}} entity;
  final FocusScopeNode focusScopeNode;
  final void Function()? onEdit;
  final void Function()? onDelete;
  const {{feature.pascalCase()}}Widget({
    super.key,
    required this.entity,
    required this.focusScopeNode,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('{{#properties}}${entity.{{name}}} {{/properties}}'),
      trailing: onDelete != null
          ? IconButton(
              key: Key('{{feature}}-${entity.id}-delete-button'),
              icon: Icon(Icons.delete, color: Colors.red.shade300),
              onPressed: onDelete,
            )
          : null,
      onTap: onEdit,
    );
  }
}
