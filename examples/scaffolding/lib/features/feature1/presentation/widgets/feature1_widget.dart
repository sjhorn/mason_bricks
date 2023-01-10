import 'package:flutter/material.dart';

import 'package:scaffolding_sample/features/feature1/feature1.dart';

class Feature1Widget extends StatelessWidget {
  final Feature1 entity;
  final FocusScopeNode focusScopeNode;
  final void Function()? onEdit;
  final void Function()? onDelete;
  const Feature1Widget({
    super.key,
    required this.entity,
    required this.focusScopeNode,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${entity.firstName} ${entity.lastName} ${entity.registered} ${entity.age} '),
      trailing: onDelete != null
          ? IconButton(
              key: Key('feature1-${entity.id}-delete-button'),
              icon: Icon(Icons.delete, color: Colors.red.shade300),
              onPressed: onDelete,
            )
          : null,
      onTap: onEdit,
    );
  }
}
