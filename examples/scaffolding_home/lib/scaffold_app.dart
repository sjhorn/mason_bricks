import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scaffolding_sample/features/feature1/feature1.dart';

class App extends StatelessWidget {
  final NavigatorObserver? navigatorObserver;
  const App({super.key, this.navigatorObserver});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: navigatorObserver != null ? [navigatorObserver!] : [],
      debugShowCheckedModeBanner: false,
      title: 'Scaffold App',
      home: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(title: const Text('Features')),
          body: ListView(children: [
              ListTile(
                key: const Key('feature1-feature-tile'),
                leading: const Icon(Icons.view_list, color: Colors.green),
                horizontalTitleGap: 0,
                title: const Text('Feature1'),
                onTap: () => Navigator.of(context).push(Feature1ReadView.route()),
              ),
          ]),
        );
      }),
    );
  }
}

Widget appWidget() {
  final repoFeature1 = Feature1RepositoryImpl();
  return 
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<Feature1Repository>.value(
          value: repoFeature1,
        ),
      ],
      child: const App(),
  );
}