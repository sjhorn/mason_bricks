
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:scaffolding_sample/features/feature1/feature1.dart';

class Feature1EditView extends StatelessWidget {
  static Key topLeftButtonKey = const Key('feature1-close-button');
  static Key bottomLeftButtonKey = const Key('feature1-delete-button');
  static Key bottomRightButtonKey = const Key('feature1-submit-button');

  final Feature1? entity;
  final Feature1EditBloc? bloc;

  const Feature1EditView({super.key, this.entity, this.bloc});

  static MaterialPageRoute route([Feature1? entity]) {
    return MaterialPageRoute(
      builder: (context) => Feature1EditView(entity: entity),
      settings: RouteSettings(name: '/editFeature1', arguments: [entity]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => bloc ?? Feature1EditBloc(context.read<Feature1Repository>(), entity),
        child: Builder(builder: (context) {
          return BlocConsumer<Feature1EditBloc, Feature1EditState>(
            listener: (context, state) {
              if (state.status == Feature1EditStatus.success) {
                Navigator.of(context).pop(state.feature1);
              }
            },
            builder: (context, state) {
              return Scaffold(
                appBar: AppBar(
                  title: Text('${entity == null ? "Create" : "Update"} Feature1'),
                  leading: IconButton(
                    key: Feature1EditView.topLeftButtonKey,
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
                      children: const [
                        _FirstNameField(),
                        _LastNameField(),
                        _RegisteredField(),
                        _AgeField(),
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
                      key: Feature1EditView.bottomLeftButtonKey,
                      child: const Icon(Icons.delete),
                      onPressed: () => context
                          .read<Feature1EditBloc>()
                          .add(Feature1EditEventDelete()),
                    ) : Container(),
                    const SizedBox(width: 10),
                    FloatingActionButton(
                      backgroundColor: Colors.green,
                      key: Feature1EditView.bottomRightButtonKey,
                      child: const Icon(Icons.check),
                      onPressed: () => context
                          .read<Feature1EditBloc>()
                          .add(Feature1EditEventSubmitted()),
                    ),
                  ],
                ),
              );
            },
          );
        }));
  }
}

class _FirstNameField extends StatelessWidget {
  const _FirstNameField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<Feature1EditBloc>().state;
    final hintText = state.feature1?.firstName ?? 'Your first name';

    return TextFormField(
      autofocus: true,
      key: const Key('edit-firstName-field'),
      initialValue: state.firstName.toString(),
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: 'First Name',
        hintText: hintText.toString(),
      ),
      maxLength: 255,
      onChanged: (value) {
        context
            .read<Feature1EditBloc>()
            .add(Feature1EditEventFirstNameChanged(toType('String', value, '')) );
      },
      onEditingComplete: () =>
          context.read<Feature1EditBloc>().add(Feature1EditEventSubmitted()),
    );
  }
}

class _LastNameField extends StatelessWidget {
  const _LastNameField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<Feature1EditBloc>().state;
    final hintText = state.feature1?.lastName ?? 'Your surname';

    return TextFormField(
      autofocus: true,
      key: const Key('edit-lastName-field'),
      initialValue: state.lastName.toString(),
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: 'Last Name',
        hintText: hintText.toString(),
      ),
      maxLength: 255,
      onChanged: (value) {
        context
            .read<Feature1EditBloc>()
            .add(Feature1EditEventLastNameChanged(toType('String', value, '')) );
      },
      onEditingComplete: () =>
          context.read<Feature1EditBloc>().add(Feature1EditEventSubmitted()),
    );
  }
}

class _RegisteredField extends StatelessWidget {
  const _RegisteredField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<Feature1EditBloc>().state;
    final hintText = state.feature1?.registered ?? false;

    return TextFormField(
      autofocus: true,
      key: const Key('edit-registered-field'),
      initialValue: state.registered.toString(),
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: 'Registered',
        hintText: hintText.toString(),
      ),
      maxLength: 255,
      onChanged: (value) {
        context
            .read<Feature1EditBloc>()
            .add(Feature1EditEventRegisteredChanged(toType('bool', value, false)) );
      },
      onEditingComplete: () =>
          context.read<Feature1EditBloc>().add(Feature1EditEventSubmitted()),
    );
  }
}

class _AgeField extends StatelessWidget {
  const _AgeField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<Feature1EditBloc>().state;
    final hintText = state.feature1?.age ?? 21;

    return TextFormField(
      autofocus: true,
      key: const Key('edit-age-field'),
      initialValue: state.age.toString(),
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: 'Age',
        hintText: hintText.toString(),
      ),
      maxLength: 255,
      onChanged: (value) {
        context
            .read<Feature1EditBloc>()
            .add(Feature1EditEventAgeChanged(toType('int', value, 0)) );
      },
      onEditingComplete: () =>
          context.read<Feature1EditBloc>().add(Feature1EditEventSubmitted()),
    );
  }
}


dynamic toType(String type, String value, dynamic emptyValue) {
  switch (type) {
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