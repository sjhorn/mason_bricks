
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:{{package}}/features/{{feature}}/{{feature}}.dart';

class {{feature.pascalCase()}}EditView extends StatelessWidget {
  static Key topLeftButtonKey = const Key('{{feature}}-close-button');
  static Key bottomLeftButtonKey = const Key('{{feature}}-delete-button');
  static Key bottomRightButtonKey = const Key('{{feature}}-submit-button');

  final {{feature.pascalCase()}}? entity;
  final {{feature.pascalCase()}}EditBloc? bloc;

  const {{feature.pascalCase()}}EditView({super.key, this.entity, this.bloc});

  static MaterialPageRoute route([{{feature.pascalCase()}}? entity]) {
    return MaterialPageRoute(
      builder: (context) => {{feature.pascalCase()}}EditView(entity: entity),
      settings: RouteSettings(name: '/edit{{feature.pascalCase()}}', arguments: [entity]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => bloc ?? {{feature.pascalCase()}}EditBloc(context.read<{{feature.pascalCase()}}Repository>(), entity),
        child: Builder(builder: (context) {
          return BlocConsumer<{{feature.pascalCase()}}EditBloc, {{feature.pascalCase()}}EditState>(
            listener: (context, state) {
              if (state.status == {{feature.pascalCase()}}EditStatus.success) {
                Navigator.of(context).pop(state.{{feature}});
              }
            },
            builder: (context, state) {
              return Scaffold(
                appBar: AppBar(
                  title: Text('${entity == null ? "Create" : "Update"} {{feature.pascalCase()}}'),
                  leading: IconButton(
                    key: {{feature.pascalCase()}}EditView.topLeftButtonKey,
                    onPressed: () {
                      Navigator.of(context).pop<bool>(false);
                    },
                    icon: const Icon(
                      Icons.close,
                    ),
                  ),
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: const [{{#properties}}
                        _{{name.pascalCase()}}Field(),{{/properties}}
                      ],
                    ),
                  ),
                ),
                floatingActionButton: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    entity != null ? FloatingActionButton(
                      heroTag: null,
                      backgroundColor: Colors.red.shade300,
                      key: {{feature.pascalCase()}}EditView.bottomLeftButtonKey,
                      child: const Icon(Icons.delete),
                      onPressed: () => context
                          .read<{{feature.pascalCase()}}EditBloc>()
                          .add({{feature.pascalCase()}}EditEventDelete()),
                    ) : Container(),
                    const SizedBox(width: 10),
                    FloatingActionButton(
                      backgroundColor: Colors.green,
                      key: {{feature.pascalCase()}}EditView.bottomRightButtonKey,
                      child: const Icon(Icons.check),
                      onPressed: () => context
                          .read<{{feature.pascalCase()}}EditBloc>()
                          .add({{feature.pascalCase()}}EditEventSubmitted()),
                    ),
                  ],
                ),
              );
            },
          );
        }));
  }
}
{{#properties}}
class _{{name.pascalCase()}}Field extends StatelessWidget {
  const _{{name.pascalCase()}}Field({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<{{feature.pascalCase()}}EditBloc>().state;
    final hintText = state.{{name}};

    return TextFormField(
      autofocus: true,
      key: const Key('edit-{{name}}-field'),
      initialValue: state.{{name}}.toString(),
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: '{{name.titleCase()}}',
        hintText: hintText.toString(),
      ),
      maxLength: 255,
      onChanged: (value) {
        context
            .read<{{feature.pascalCase()}}EditBloc>()
            .add({{feature.pascalCase()}}EditEvent{{name.pascalCase()}}Changed(toType('{{type}}', value, {{{emptyValue}}})) );
      },
      onEditingComplete: () =>
          context.read<{{feature.pascalCase()}}EditBloc>().add({{feature.pascalCase()}}EditEventSubmitted()),
    );
  }
}
{{/properties}}

dynamic toType(String type, String value, dynamic emptyValue) {
  switch (type) {
    case 'double':
      try  {
        return double.parse(value);
      } catch(e) {
        return emptyValue;
      }
    case 'int':
      try  {
        return int.parse(value);
      } catch(e) {
        return emptyValue;
      }
    case 'bool':
      return value.toLowerCase().endsWith('true');
    default:
      return value;
  }
}