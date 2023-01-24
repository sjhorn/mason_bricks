
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:{{package}}/shared/presentation/shared.dart';

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
                      children: [{{#properties}}
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
class _{{name.pascalCase()}}Field extends EditWidget<{{type}}> {
  _{{name.pascalCase()}}Field()
      : super(
          key: const Key('edit-{{name}}-field'),
          labelText: '{{name.titleCase()}}',
          initialValue: (context) =>
              context.watch<{{feature.pascalCase()}}EditBloc>().state.{{name}},
          changedEvent: (context, newValue) => context
              .read<{{feature.pascalCase()}}EditBloc>()
              .add({{feature.pascalCase()}}EditEvent{{name.pascalCase()}}Changed(newValue)),
          submittedEvent: (context) => context
              .read<{{feature.pascalCase()}}EditBloc>()
              .add({{feature.pascalCase()}}EditEventSubmitted()),
        );
}{{/properties}}

