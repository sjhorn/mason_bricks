import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:scaffolding_sample/features/feature1/feature1.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockFeature1Repository extends Mock implements Feature1Repository {}

class MockFeature1EditBloc extends Mock implements Feature1EditBloc {}

class FakeFeature1EditEvent extends Fake implements Feature1EditEvent {}

class FakeRoute extends Fake implements Route<dynamic> {}

void main() {
  late MockFeature1Repository repo;
  late MockFeature1EditBloc mockFeature1EditBloc;
  late MockNavigatorObserver mockNavigatorObserver;

  late StreamController<Feature1EditState> blocStreamController;
  final testFeature1 =
      Feature1(id: '9999', firstName:'testString', lastName:'testString', registered:true, age:1, );

  setUpAll(() {
    registerFallbackValue(FakeFeature1EditEvent());
    registerFallbackValue(FakeRoute());
  });

  setUp(() {
    repo = MockFeature1Repository();
    mockFeature1EditBloc = MockFeature1EditBloc();
    mockNavigatorObserver = MockNavigatorObserver();
    blocStreamController = StreamController<Feature1EditState>.broadcast();

    when(() => mockFeature1EditBloc.stream)
        .thenAnswer((_) => blocStreamController.stream);
    when(() => mockFeature1EditBloc.close())
        .thenAnswer((_) async {});
  });

  tearDown(() {
    blocStreamController.close();
  });

  Widget makeTestableWidget(Widget body) {
    return RepositoryProvider<Feature1Repository>(
      create: ((context) => repo),
      child: BlocProvider<Feature1EditBloc>.value(
        value: mockFeature1EditBloc,
        child: MaterialApp(
          home: body,
          navigatorObservers: [mockNavigatorObserver],
        ),
      ),
    );
  }

  group('edit feature1 view ...', () {
    testWidgets('renders fields in initial state', (tester) async {
      var editIssueView = const Feature1EditView(key: Key('test'));

      var widget = makeTestableWidget(editIssueView);

      when(() => mockFeature1EditBloc.state).thenReturn(const Feature1EditState(firstName:'testString', lastName:'testString', registered:true, age:1, ));

      await tester.pumpWidget(widget);

      expect(find.byType(TextField), equals(findsWidgets));
    });

     testWidgets('close button pops navigator', (tester) async {
      var widget = makeTestableWidget(Feature1EditView(bloc: mockFeature1EditBloc));

      when(() => mockFeature1EditBloc.state).thenReturn(const Feature1EditState(firstName:'testString', lastName:'testString', registered:true, age:1, ));
      await tester.pumpWidget(widget);

      await tester.tap(find.byKey(Feature1EditView.topLeftButtonKey));
      await tester.pumpWidget(widget);

      verify(() => mockNavigatorObserver.didPop(any(), any())).called(1);
    });

     testWidgets('success state pops navigator', (tester) async {
      var widget = makeTestableWidget(Feature1EditView(bloc: mockFeature1EditBloc));
      const initialState = Feature1EditState(
        status: Feature1EditStatus.success, 
        firstName:'testString',
        lastName:'testString',
        registered:true,
        age:1,
      );

      when(() => mockFeature1EditBloc.state).thenReturn(initialState);
      await tester.pumpWidget(widget);

      blocStreamController
          .add(initialState.copyWith(status: Feature1EditStatus.success));
      await tester.pump();

      verify(() => mockNavigatorObserver.didPop(any(), any())).called(1);
    });

    testWidgets('tap add button triggers add event', (tester) async {
      var widget = makeTestableWidget(Feature1EditView(bloc: mockFeature1EditBloc));

      const initialState = Feature1EditState(
        status: Feature1EditStatus.success, 
        firstName:'testString',
        lastName:'testString',
        registered:true,
        age:1,
      );

      when(() => mockFeature1EditBloc.state).thenReturn(initialState);
      await tester.pumpWidget(widget);

      final addEvent = Feature1EditEventSubmitted();

      when(() => mockFeature1EditBloc.add(addEvent)).thenAnswer((_) async {}); 
      await tester.tap(find.byKey(Feature1EditView.bottomRightButtonKey));
      await tester.pumpWidget(widget);

      verify(() => mockFeature1EditBloc.add(addEvent)).called(1);
    });

    testWidgets('tap delete button triggers delete event', (tester) async {
      var widget = makeTestableWidget(Feature1EditView(bloc: mockFeature1EditBloc, entity: testFeature1));

      final initialState = Feature1EditState(
        status: Feature1EditStatus.success, 
        feature1: testFeature1,
        firstName:'testString',
        lastName:'testString',
        registered:true,
        age:1,
      );

      when(() => mockFeature1EditBloc.state).thenReturn(initialState);
      await tester.pumpWidget(widget);

      final deleteEvent = Feature1EditEventDelete();

      when(() => mockFeature1EditBloc.add(deleteEvent)).thenAnswer((_) async {}); 
      await tester.tap(find.byKey(Feature1EditView.bottomLeftButtonKey));
      await tester.pumpWidget(widget);

      verify(() => mockFeature1EditBloc.add(deleteEvent)).called(1);
    });
    
    testWidgets('edit firstName sends event firstName changed', (tester) async {
      final initialState = Feature1EditState(
        status: Feature1EditStatus.success, 
        feature1: testFeature1,
        firstName:'testString',
        lastName:'testString',
        registered:true,
        age:1,
      );
      const newValue = 'testString';
      const event = Feature1EditEventFirstNameChanged(newValue);
      var view = Feature1EditView(
        bloc: mockFeature1EditBloc,
        entity: testFeature1,
      );
      var widget = makeTestableWidget(view);

      when(() => mockFeature1EditBloc.state).thenReturn(initialState);
      when(() => mockFeature1EditBloc.add(event)).thenAnswer((invocation) {});
      await tester.pumpWidget(widget);

      await tester.enterText(
        find.byKey(const Key('edit-firstName-field')),
        '',
      );
      await tester.pump();
      await tester.enterText(
        find.byKey(const Key('edit-firstName-field')),
        newValue.toString(),
      );
      await tester.pump();

      verify(() => mockFeature1EditBloc.add(event)).called(greaterThan(0));
    });

    testWidgets('enter completes editing for firstName', (tester) async {
       final initialState = Feature1EditState(
        status: Feature1EditStatus.success, 
        feature1: testFeature1,
        firstName:'testString',
        lastName:'testString',
        registered:true,
        age:1,
      );
      final event = Feature1EditEventSubmitted();
      var view = Feature1EditView(
        bloc: mockFeature1EditBloc,
        entity: testFeature1,
      );
      var widget = makeTestableWidget(view);

      when(() => mockFeature1EditBloc.state).thenReturn(initialState);
      when(() => mockFeature1EditBloc.add(event)).thenAnswer((invocation) {});
      await tester.pumpWidget(widget);

      await tester.tap(find.byKey(const Key('edit-firstName-field')));
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpWidget(widget);

      verify(() => mockFeature1EditBloc.add(event)).called(1);
    });
    
    testWidgets('edit lastName sends event lastName changed', (tester) async {
      final initialState = Feature1EditState(
        status: Feature1EditStatus.success, 
        feature1: testFeature1,
        firstName:'testString',
        lastName:'testString',
        registered:true,
        age:1,
      );
      const newValue = 'testString';
      const event = Feature1EditEventLastNameChanged(newValue);
      var view = Feature1EditView(
        bloc: mockFeature1EditBloc,
        entity: testFeature1,
      );
      var widget = makeTestableWidget(view);

      when(() => mockFeature1EditBloc.state).thenReturn(initialState);
      when(() => mockFeature1EditBloc.add(event)).thenAnswer((invocation) {});
      await tester.pumpWidget(widget);

      await tester.enterText(
        find.byKey(const Key('edit-lastName-field')),
        '',
      );
      await tester.pump();
      await tester.enterText(
        find.byKey(const Key('edit-lastName-field')),
        newValue.toString(),
      );
      await tester.pump();

      verify(() => mockFeature1EditBloc.add(event)).called(greaterThan(0));
    });

    testWidgets('enter completes editing for lastName', (tester) async {
       final initialState = Feature1EditState(
        status: Feature1EditStatus.success, 
        feature1: testFeature1,
        firstName:'testString',
        lastName:'testString',
        registered:true,
        age:1,
      );
      final event = Feature1EditEventSubmitted();
      var view = Feature1EditView(
        bloc: mockFeature1EditBloc,
        entity: testFeature1,
      );
      var widget = makeTestableWidget(view);

      when(() => mockFeature1EditBloc.state).thenReturn(initialState);
      when(() => mockFeature1EditBloc.add(event)).thenAnswer((invocation) {});
      await tester.pumpWidget(widget);

      await tester.tap(find.byKey(const Key('edit-lastName-field')));
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpWidget(widget);

      verify(() => mockFeature1EditBloc.add(event)).called(1);
    });
    
    testWidgets('edit registered sends event registered changed', (tester) async {
      final initialState = Feature1EditState(
        status: Feature1EditStatus.success, 
        feature1: testFeature1,
        firstName:'testString',
        lastName:'testString',
        registered:true,
        age:1,
      );
      const newValue = true;
      const event = Feature1EditEventRegisteredChanged(newValue);
      var view = Feature1EditView(
        bloc: mockFeature1EditBloc,
        entity: testFeature1,
      );
      var widget = makeTestableWidget(view);

      when(() => mockFeature1EditBloc.state).thenReturn(initialState);
      when(() => mockFeature1EditBloc.add(event)).thenAnswer((invocation) {});
      await tester.pumpWidget(widget);

      await tester.enterText(
        find.byKey(const Key('edit-registered-field')),
        '',
      );
      await tester.pump();
      await tester.enterText(
        find.byKey(const Key('edit-registered-field')),
        newValue.toString(),
      );
      await tester.pump();

      verify(() => mockFeature1EditBloc.add(event)).called(greaterThan(0));
    });

    testWidgets('enter completes editing for registered', (tester) async {
       final initialState = Feature1EditState(
        status: Feature1EditStatus.success, 
        feature1: testFeature1,
        firstName:'testString',
        lastName:'testString',
        registered:true,
        age:1,
      );
      final event = Feature1EditEventSubmitted();
      var view = Feature1EditView(
        bloc: mockFeature1EditBloc,
        entity: testFeature1,
      );
      var widget = makeTestableWidget(view);

      when(() => mockFeature1EditBloc.state).thenReturn(initialState);
      when(() => mockFeature1EditBloc.add(event)).thenAnswer((invocation) {});
      await tester.pumpWidget(widget);

      await tester.tap(find.byKey(const Key('edit-registered-field')));
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpWidget(widget);

      verify(() => mockFeature1EditBloc.add(event)).called(1);
    });
    
    testWidgets('edit age sends event age changed', (tester) async {
      final initialState = Feature1EditState(
        status: Feature1EditStatus.success, 
        feature1: testFeature1,
        firstName:'testString',
        lastName:'testString',
        registered:true,
        age:1,
      );
      const newValue = 1;
      const event = Feature1EditEventAgeChanged(newValue);
      var view = Feature1EditView(
        bloc: mockFeature1EditBloc,
        entity: testFeature1,
      );
      var widget = makeTestableWidget(view);

      when(() => mockFeature1EditBloc.state).thenReturn(initialState);
      when(() => mockFeature1EditBloc.add(event)).thenAnswer((invocation) {});
      await tester.pumpWidget(widget);

      await tester.enterText(
        find.byKey(const Key('edit-age-field')),
        '',
      );
      await tester.pump();
      await tester.enterText(
        find.byKey(const Key('edit-age-field')),
        newValue.toString(),
      );
      await tester.pump();

      verify(() => mockFeature1EditBloc.add(event)).called(greaterThan(0));
    });

    testWidgets('enter completes editing for age', (tester) async {
       final initialState = Feature1EditState(
        status: Feature1EditStatus.success, 
        feature1: testFeature1,
        firstName:'testString',
        lastName:'testString',
        registered:true,
        age:1,
      );
      final event = Feature1EditEventSubmitted();
      var view = Feature1EditView(
        bloc: mockFeature1EditBloc,
        entity: testFeature1,
      );
      var widget = makeTestableWidget(view);

      when(() => mockFeature1EditBloc.state).thenReturn(initialState);
      when(() => mockFeature1EditBloc.add(event)).thenAnswer((invocation) {});
      await tester.pumpWidget(widget);

      await tester.tap(find.byKey(const Key('edit-age-field')));
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpWidget(widget);

      verify(() => mockFeature1EditBloc.add(event)).called(1);
    });
    

    test('test toType method', () async {
        expect(toType('String', 'good', 'backup'), equals('good'));
        expect(toType('int', '1', 2), equals(1));
        expect(toType('int', 'one', 2), equals(2));
        expect(toType('bool', 'true', false), equals(true));
        expect(toType('bool', '_', false), equals(false));
      },
    );
  });
}