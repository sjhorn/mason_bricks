import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
{{#features}}import 'package:{{package}}/features/{{.}}/{{.}}.dart';
{{/features}}
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
              {{#features}}ListTile(
                key: const Key('{{.}}-feature-tile'),
                leading: const Icon(Icons.view_list, color: Colors.green),
                horizontalTitleGap: 0,
                title: const Text('{{#sentenceCase}}{{.}}{{/sentenceCase}}'),
                onTap: () => Navigator.of(context).push({{#pascalCase}}{{.}}{{/pascalCase}}ReadView.route()),
              ),{{/features}}
          ]),
        );
      }),
    );
  }
}

Widget appWidget() {
  {{#features}}final repo{{#pascalCase}}{{.}}{{/pascalCase}} = {{#pascalCase}}{{.}}{{/pascalCase}}RepositoryImpl();
  {{/features}}return 
    MultiRepositoryProvider(
      providers: [
        {{#features}}RepositoryProvider<{{#pascalCase}}{{.}}{{/pascalCase}}Repository>.value(
          value: repo{{#pascalCase}}{{.}}{{/pascalCase}},
        ),
      {{/features}}],
      child: const App(),
  );
}