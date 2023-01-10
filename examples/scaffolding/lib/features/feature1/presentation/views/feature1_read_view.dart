 import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scaffolding_sample/shared/presentation/list_table.dart';

import 'package:scaffolding_sample/features/feature1/feature1.dart';

class Feature1ReadView extends StatefulWidget {
  static Key topLeftButtonKey = const Key('feature1-home-button');
  static Key topRightButtonKey = const Key('feature1-refresh-button');
  static Key bottomRightButtonKey = const Key('feature1-done-button');
  static Key deleteButtonKey(id) => Key('feature1-$id-delete-button');

  final Feature1ReadBloc? bloc;

  const Feature1ReadView({super.key, this.bloc});
  
  static MaterialPageRoute route([Feature1ReadBloc? bloc]) {
    return MaterialPageRoute(
      builder: (context) => Feature1ReadView(bloc: bloc),
      settings: const RouteSettings(name: '/readFeature1'),
    );
  }

  @override
  State<Feature1ReadView> createState() => _Feature1ReadViewState();
}

class _Feature1ReadViewState extends State<Feature1ReadView> {
  List<Feature1> _list = [];
  int _totalCount = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => widget.bloc ?? Feature1ReadBloc(context.read<Feature1Repository>()),
      child: Builder(builder: (context) {
        Feature1ReadBloc bloc = context.read<Feature1ReadBloc>();
        return Scaffold(
          appBar: AppBar(
            title: const Text('Feature1 List'),
            leading: IconButton(
              key: Feature1ReadView.topLeftButtonKey,
              onPressed: () {
                Navigator.of(context).pop<bool>(false);
              },
              icon: const Icon(Icons.home,),
            ),
            actions:  [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  key: Feature1ReadView.topRightButtonKey,
                  onPressed: () => bloc.add(const Feature1ReadEventReload()),
                  icon: const Icon(Icons.refresh)
                ),
              )
            ],
          ),
          body: BlocBuilder<Feature1ReadBloc, Feature1ReadState>(
            builder: (context, state) {
              switch (state.runtimeType) {
                case Feature1ReadStateCreate:
                  _list.add(state.selectedFeature1!);
                  _totalCount++;
                  break;
                case Feature1ReadStateUpdate:
                  final selected = state.selectedFeature1!;
                  var toUpdate =
                      _list.firstWhere((element) => selected.id == element.id);
                  _list[_list.indexOf(toUpdate)] = selected;
                  break;
                case Feature1ReadStateDelete:
                  final selected = state.selectedFeature1!;
                  _list.retainWhere((element) => element.id != selected.id);
                  _totalCount--;
                  break;
                case Feature1ReadStateFailure:
                  return _errorWidget(state.message);
                case Feature1ReadStateInitial:
                case Feature1ReadStateLoading:
                  return _loadingWidget();
                case Feature1ReadStateSuccess:
                  _list = [...state.feature1s];
                  _totalCount = state.totalCount;
                  break;
                default:
              }
              return _listWidget(bloc, state);
            },
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.green,
            key: Feature1ReadView.bottomRightButtonKey,
            child: const Icon(Icons.add),
            onPressed: () => _create(),
          ),
        );
      }),
    );
  }

  Widget _listWidget(bloc, state) {
    return ListTable<Feature1>(
      totalCount: _totalCount,
      cacheCount: _list.length,
      columns: const ['First name','Last name','Registered','Age', ''],
      cache: _list,
      renderRow: (entity) => [
        ...[entity.firstName.toString(), entity.lastName.toString(), entity.registered.toString(), entity.age.toString(), ]
            .map((e) => Text(e)),
        IconButton(
          key: Feature1ReadView.deleteButtonKey(entity.id),
          icon: Icon(Icons.delete, color: Colors.red.shade300),
          onPressed: () => bloc.add(Feature1ReadEventDelete(entity)),
        )
      ],
      readMore: () => bloc.add(const Feature1ReadEventReadMore()),
      edit: (entity) => _edit(entity),
    );
    // return ListView.builder(
    //   controller: _scrollController,
    //   itemCount: _list.length == _totalCount ? _totalCount : _list.length + 1,
    //   itemBuilder: (context, index) {
    //     if (index == _list.length) {
    //       Future.delayed(
    //           Duration.zero, 
    //           () => bloc.add(const Feature1ReadEventReadMore()),
    //       );
    //       return const Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     } else {
    //       var entity = _list[index];
    //       return Feature1Widget(
    //         entity: entity,
    //         key: ValueKey(entity.id),
    //         focusScopeNode: _node,
    //         onDelete: () => bloc.add(Feature1ReadEventDelete(entity)),
    //         onEdit: () => _edit(entity),
    //       );
    //     }
    //   },
    // );
  }

  void _create() {
    Navigator.of(context).push(Feature1EditView.route());
  }

  void _edit(feature1) {
    Navigator.of(context).push(Feature1EditView.route(feature1));
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
