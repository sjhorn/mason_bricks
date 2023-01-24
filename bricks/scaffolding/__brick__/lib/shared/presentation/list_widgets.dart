import 'package:flutter/material.dart';

class ListWidgetString extends StatelessWidget {
  final String entity;
  const ListWidgetString(this.entity, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(entity);
  }
}

class ListWidgetDouble extends StatelessWidget {
  final double entity;
  const ListWidgetDouble(this.entity, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListWidgetString(entity.toString());
  }
}

class ListWidgetInt extends StatelessWidget {
  final int entity;
  const ListWidgetInt(this.entity, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListWidgetString(entity.toString());
  }
}

class ListWidgetBool extends StatelessWidget {
  final bool entity;
  const ListWidgetBool(this.entity, {super.key});

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: entity,
      splashRadius: 0,
      onChanged: null,
    );
  }
}

class ListWidgetDelete extends StatelessWidget {
  final Function() onPressed;
  final Key idKey;

  const ListWidgetDelete({
    required this.idKey,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: idKey,
      icon: Icon(Icons.delete, color: Colors.red.shade300),
      onPressed: onPressed,
    );
  }
}
