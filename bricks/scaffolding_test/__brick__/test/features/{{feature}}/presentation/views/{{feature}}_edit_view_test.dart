import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:{{package}}/features/{{feature}}/{{feature}}.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class Mock{{feature.pascalCase()}}Repository extends Mock implements {{feature.pascalCase()}}Repository {}

class Mock{{feature.pascalCase()}}EditBloc extends Mock implements {{feature.pascalCase()}}EditBloc {}

class Fake{{feature.pascalCase()}}EditEvent extends Fake implements {{feature.pascalCase()}}EditEvent {}

class FakeRoute extends Fake implements Route<dynamic> {}

void main() {
  late Mock{{feature.pascalCase()}}Repository repo;
  late Mock{{feature.pascalCase()}}EditBloc mock{{feature.pascalCase()}}EditBloc;
  late MockNavigatorObserver mockNavigatorObserver;

  late StreamController<{{feature.pascalCase()}}EditState> blocStreamController;
  final test{{feature.pascalCase()}} =
      {{feature.pascalCase()}}(id: '9999', {{#properties}}{{name}}:{{{testValue}}}, {{/properties}});

  setUpAll(() {
    registerFallbackValue(Fake{{feature.pascalCase()}}EditEvent());
    registerFallbackValue(FakeRoute());
  });

  setUp(() {
    repo = Mock{{feature.pascalCase()}}Repository();
    mock{{feature.pascalCase()}}EditBloc = Mock{{feature.pascalCase()}}EditBloc();
    mockNavigatorObserver = MockNavigatorObserver();
    blocStreamController = StreamController<{{feature.pascalCase()}}EditState>.broadcast();

    when(() => mock{{feature.pascalCase()}}EditBloc.stream)
        .thenAnswer((_) => blocStreamController.stream);
    when(() => mock{{feature.pascalCase()}}EditBloc.close())
        .thenAnswer((_) async {});
  });

  tearDown(() {
    blocStreamController.close();
  });

  Widget makeTestableWidget(Widget body) {
    return RepositoryProvider<{{feature.pascalCase()}}Repository>(
      create: ((context) => repo),
      child: BlocProvider<{{feature.pascalCase()}}EditBloc>.value(
        value: mock{{feature.pascalCase()}}EditBloc,
        child: MaterialApp(
          home: body,
          navigatorObservers: [mockNavigatorObserver],
        ),
      ),
    );
  }
  
  runWidgetChange(tester, fieldFinder, testValue) async {
    await tester.ensureVisible(fieldFinder);
    if(testValue is bool) {
      await tester.tap(fieldFinder);
      await tester.pump();
    } else {
      await tester.enterText(fieldFinder, '');
      await tester.pump();
      await tester.enterText(fieldFinder, '$testValue');
      await tester.pump();
    }
  }

  R makeChangeEvent<T,R>(R Function(T) ctor, T value) {
    if(value is bool) {
      return ctor(!value as T);
    } else {
      return ctor(value);
    }
  }

  group('edit {{feature}} view ...', () {
    testWidgets('renders fields in initial state', (tester) async {
      var editIssueView = const {{feature.pascalCase()}}EditView(key: Key('test'));

      var widget = makeTestableWidget(editIssueView);

      when(() => mock{{feature.pascalCase()}}EditBloc.state).thenReturn(const {{feature.pascalCase()}}EditState({{#properties}}{{name}}:{{{testValue}}}, {{/properties}}));

      await tester.pumpWidget(widget);

      expect(find.byType(TextField), equals(findsWidgets));
    });

     testWidgets('close button pops navigator', (tester) async {
      var widget = makeTestableWidget({{feature.pascalCase()}}EditView(bloc: mock{{feature.pascalCase()}}EditBloc));

      when(() => mock{{feature.pascalCase()}}EditBloc.state).thenReturn(const {{feature.pascalCase()}}EditState({{#properties}}{{name}}:{{{testValue}}}, {{/properties}}));
      await tester.pumpWidget(widget);

      final testFinder = find.byKey({{feature.pascalCase()}}EditView.topLeftButtonKey);
      await tester.ensureVisible(testFinder);
      await tester.tap(testFinder);

      await tester.pumpWidget(widget);

      verify(() => mockNavigatorObserver.didPop(any(), any())).called(1);
    });

     testWidgets('success state pops navigator', (tester) async {
      var widget = makeTestableWidget({{feature.pascalCase()}}EditView(bloc: mock{{feature.pascalCase()}}EditBloc));
      const initialState = {{feature.pascalCase()}}EditState(
        status: {{feature.pascalCase()}}EditStatus.success, {{#properties}}
        {{name}}:{{{testValue}}},{{/properties}}
      );

      when(() => mock{{feature.pascalCase()}}EditBloc.state).thenReturn(initialState);
      await tester.pumpWidget(widget);

      blocStreamController
          .add(initialState.copyWith(status: {{feature.pascalCase()}}EditStatus.success));
      await tester.pump();

      verify(() => mockNavigatorObserver.didPop(any(), any())).called(1);
    });

    testWidgets('tap add button triggers add event', (tester) async {
      var widget = makeTestableWidget({{feature.pascalCase()}}EditView(bloc: mock{{feature.pascalCase()}}EditBloc));

      const initialState = {{feature.pascalCase()}}EditState(
        status: {{feature.pascalCase()}}EditStatus.success, {{#properties}}
        {{name}}:{{{testValue}}},{{/properties}}
      );

      when(() => mock{{feature.pascalCase()}}EditBloc.state).thenReturn(initialState);
      await tester.pumpWidget(widget);

      final addEvent = {{feature.pascalCase()}}EditEventSubmitted();

      when(() => mock{{feature.pascalCase()}}EditBloc.add(addEvent)).thenAnswer((_) async {}); 

      final testFinder = find.byKey({{feature.pascalCase()}}EditView.bottomRightButtonKey);
      await tester.ensureVisible(testFinder);
      await tester.tap(testFinder);

      await tester.pumpWidget(widget);

      verify(() => mock{{feature.pascalCase()}}EditBloc.add(addEvent)).called(1);
    });

    testWidgets('tap delete button triggers delete event', (tester) async {
      var widget = makeTestableWidget({{feature.pascalCase()}}EditView(bloc: mock{{feature.pascalCase()}}EditBloc, entity: test{{feature.pascalCase()}}));

      final initialState = {{feature.pascalCase()}}EditState(
        status: {{feature.pascalCase()}}EditStatus.success, 
        {{feature}}: test{{feature.pascalCase()}},{{#properties}}
        {{name}}:{{{testValue}}},{{/properties}}
      );

      when(() => mock{{feature.pascalCase()}}EditBloc.state).thenReturn(initialState);
      await tester.pumpWidget(widget);

      final deleteEvent = {{feature.pascalCase()}}EditEventDelete();

      when(() => mock{{feature.pascalCase()}}EditBloc.add(deleteEvent)).thenAnswer((_) async {}); 

      final testFinder = find.byKey({{feature.pascalCase()}}EditView.bottomLeftButtonKey);
      await tester.ensureVisible(testFinder);
      await tester.tap(testFinder);
      
      await tester.pumpWidget(widget);

      verify(() => mock{{feature.pascalCase()}}EditBloc.add(deleteEvent)).called(1);
    });
    {{#properties}}
    testWidgets('edit {{name}} sends event {{name}} changed', (tester) async {
      final initialState = {{feature.pascalCase()}}EditState(
        status: {{feature.pascalCase()}}EditStatus.success, 
        {{feature}}: test{{feature.pascalCase()}},{{#properties}}
        {{name}}:{{{testValue}}},{{/properties}}
      );
      
      var view = {{feature.pascalCase()}}EditView(
        bloc: mock{{feature.pascalCase()}}EditBloc,
        entity: test{{feature.pascalCase()}},
      );
      var widget = makeTestableWidget(view);

      when(() => mock{{feature.pascalCase()}}EditBloc.state).thenReturn(initialState);
      final fieldFinder = find.byKey(const Key('edit-{{name}}-field'));

      final event = makeChangeEvent<{{type}}, {{feature.pascalCase()}}EditEvent{{name.pascalCase()}}Changed>({{feature.pascalCase()}}EditEvent{{name.pascalCase()}}Changed.new, {{{testValue}}});

      when(() => mockFeature1EditBloc.add(event)).thenAnswer((invocation) {});
      await tester.pumpWidget(widget);

      await runWidgetChange(tester, fieldFinder, {{{testValue}}});

      verify(() => mockFeature1EditBloc.add(event)).called(greaterThan(0));
    });

    testWidgets('enter completes editing for {{name}}', (tester) async {
       final initialState = {{feature.pascalCase()}}EditState(
        status: {{feature.pascalCase()}}EditStatus.success, 
        {{feature}}: test{{feature.pascalCase()}},{{#properties}}
        {{name}}:{{{testValue}}},{{/properties}}
      );
      final event = {{feature.pascalCase()}}EditEventSubmitted();
      var view = {{feature.pascalCase()}}EditView(
        bloc: mock{{feature.pascalCase()}}EditBloc,
        entity: test{{feature.pascalCase()}},
      );
      var widget = makeTestableWidget(view);

      when(() => mock{{feature.pascalCase()}}EditBloc.state).thenReturn(initialState);
      when(() => mock{{feature.pascalCase()}}EditBloc.add(event)).thenAnswer((invocation) {});
      await tester.pumpWidget(widget);

      final testFinder = find.byKey(const Key('edit-{{name}}-field'));
      await tester.ensureVisible(testFinder);
      await tester.tap(testFinder);
      
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpWidget(widget);

      verify(() => mock{{feature.pascalCase()}}EditBloc.add(event)).called(1);
    });
    {{/properties}}

    
  });
}