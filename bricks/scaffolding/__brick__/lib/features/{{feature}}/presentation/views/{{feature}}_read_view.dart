 import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:{{package}}/shared/presentation/list_table.dart';

import 'package:{{package}}/features/{{feature}}/{{feature}}.dart';

class {{feature.pascalCase()}}ReadView extends StatefulWidget {
  static Key topLeftButtonKey = const Key('{{feature}}-home-button');
  static Key topRightButtonKey = const Key('{{feature}}-refresh-button');
  static Key bottomRightButtonKey = const Key('{{feature}}-done-button');
  static Key deleteButtonKey(id) => Key('{{feature}}-$id-delete-button');

  final {{feature.pascalCase()}}ReadBloc? bloc;

  const {{feature.pascalCase()}}ReadView({super.key, this.bloc});
  
  static MaterialPageRoute route([{{feature.pascalCase()}}ReadBloc? bloc]) {
    return MaterialPageRoute(
      builder: (context) => {{feature.pascalCase()}}ReadView(bloc: bloc),
      settings: const RouteSettings(name: '/read{{feature.pascalCase()}}'),
    );
  }

  @override
  State<{{feature.pascalCase()}}ReadView> createState() => _{{feature.pascalCase()}}ReadViewState();
}

class _{{feature.pascalCase()}}ReadViewState extends State<{{feature.pascalCase()}}ReadView> {
  List<{{feature.pascalCase()}}> _list = [];
  int _totalCount = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => widget.bloc ?? {{feature.pascalCase()}}ReadBloc(context.read<{{feature.pascalCase()}}Repository>()),
      child: Builder(builder: (context) {
        {{feature.pascalCase()}}ReadBloc bloc = context.read<{{feature.pascalCase()}}ReadBloc>();
        return Scaffold(
          appBar: AppBar(
            title: const Text('{{feature.pascalCase()}} List'),
            leading: IconButton(
              key: {{feature.pascalCase()}}ReadView.topLeftButtonKey,
              onPressed: () {
                Navigator.of(context).pop<bool>(false);
              },
              icon: const Icon(Icons.home,),
            ),
            actions:  [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  key: {{feature.pascalCase()}}ReadView.topRightButtonKey,
                  onPressed: () => bloc.add(const {{feature.pascalCase()}}ReadEventReload()),
                  icon: const Icon(Icons.refresh)
                ),
              )
            ],
          ),
          body: BlocBuilder<{{feature.pascalCase()}}ReadBloc, {{feature.pascalCase()}}ReadState>(
            builder: (context, state) {
              switch (state.runtimeType) {
                case {{feature.pascalCase()}}ReadStateCreate:
                  _list.add(state.selected{{feature.pascalCase()}}!);
                  _totalCount++;
                  break;
                case {{feature.pascalCase()}}ReadStateUpdate:
                  final selected = state.selected{{feature.pascalCase()}}!;
                  var toUpdate =
                      _list.firstWhere((element) => selected.id == element.id);
                  _list[_list.indexOf(toUpdate)] = selected;
                  break;
                case {{feature.pascalCase()}}ReadStateDelete:
                  final selected = state.selected{{feature.pascalCase()}}!;
                  _list.retainWhere((element) => element.id != selected.id);
                  _totalCount--;
                  break;
                case {{feature.pascalCase()}}ReadStateFailure:
                  return _errorWidget(state.message);
                case {{feature.pascalCase()}}ReadStateInitial:
                case {{feature.pascalCase()}}ReadStateLoading:
                  return _loadingWidget();
                case {{feature.pascalCase()}}ReadStateSuccess:
                  _list = [...state.{{feature}}s];
                  _totalCount = state.totalCount;
                  break;
                default:
              }
              return _listWidget(bloc, state);
            },
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.green,
            key: {{feature.pascalCase()}}ReadView.bottomRightButtonKey,
            child: const Icon(Icons.add),
            onPressed: () => _create(),
          ),
        );
      }),
    );
  }

  Widget _listWidget(bloc, state) {
    return ListTable<{{feature.pascalCase()}}>(
      totalCount: _totalCount,
      cacheCount: _list.length,
      columns: const [{{#properties}}'{{name.sentenceCase()}}',{{/properties}} ''],
      cache: _list,
      renderRow: (entity) => [
        ...[{{#properties}}entity.{{name}}.toString(), {{/properties}}]
            .map((e) => Text(e)),
        IconButton(
          key: {{feature.pascalCase()}}ReadView.deleteButtonKey(entity.id),
          icon: Icon(Icons.delete, color: Colors.red.shade300),
          onPressed: () => bloc.add({{feature.pascalCase()}}ReadEventDelete(entity)),
        )
      ],
      readMore: () => bloc.add(const {{feature.pascalCase()}}ReadEventReadMore()),
      edit: (entity) => _edit(entity),
    );
    // return ListView.builder(
    //   controller: _scrollController,
    //   itemCount: _list.length == _totalCount ? _totalCount : _list.length + 1,
    //   itemBuilder: (context, index) {
    //     if (index == _list.length) {
    //       Future.delayed(
    //           Duration.zero, 
    //           () => bloc.add(const {{feature.pascalCase()}}ReadEventReadMore()),
    //       );
    //       return const Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     } else {
    //       var entity = _list[index];
    //       return {{feature.pascalCase()}}Widget(
    //         entity: entity,
    //         key: ValueKey(entity.id),
    //         focusScopeNode: _node,
    //         onDelete: () => bloc.add({{feature.pascalCase()}}ReadEventDelete(entity)),
    //         onEdit: () => _edit(entity),
    //       );
    //     }
    //   },
    // );
  }

  void _create() {
    Navigator.of(context).push({{feature.pascalCase()}}EditView.route());
  }

  void _edit({{feature}}) {
    Navigator.of(context).push({{feature.pascalCase()}}EditView.route({{feature}}));
  }

  Widget _loadingWidget() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _errorWidget(String message) {
    return Center(
      child: SizedBox(
        width: 400,
        height: 200,
        child: Column(
          children: [
            Text(message, softWrap: true),
          ],
        ),
      ),
    );
  }
}
