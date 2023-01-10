import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:scaffolding_sample/features/feature1/feature1.dart';

class MockFeature1Repository extends Mock implements Feature1Repository {}

class MockFeature1 extends Mock implements Feature1 {}

void main() {
  late MockFeature1Repository repo;
  final controller = StreamController<Feature1ChangeInfo>.broadcast();
  const id = 'test-feature1-1';
  final testFeature1 = Feature1(id: id, firstName: 'testString', lastName: 'testString', registered: true, age: 1, );
  setUp(() {
    repo = MockFeature1Repository();
    when(() => repo.read()).thenAnswer((_) => controller.stream);
    
  });
  group('edit issue bloc', () {
    
    blocTest<Feature1EditBloc, Feature1EditState>(
      'should emit [initial, with the new firstName] for firstName change',
      build: () => Feature1EditBloc(repo, testFeature1),
      act: (bloc) => bloc.add(const Feature1EditEventFirstNameChanged('testString')),
      expect: () => [
        Feature1EditState(feature1: testFeature1, firstName: 'testString', lastName: 'testString', registered: true, age: 1, ),
      ],
      wait: const Duration(milliseconds: 600),
      verify: (bloc) {},
    );
    blocTest<Feature1EditBloc, Feature1EditState>(
      'should emit [initial, with the new lastName] for lastName change',
      build: () => Feature1EditBloc(repo, testFeature1),
      act: (bloc) => bloc.add(const Feature1EditEventLastNameChanged('testString')),
      expect: () => [
        Feature1EditState(feature1: testFeature1, firstName: 'testString', lastName: 'testString', registered: true, age: 1, ),
      ],
      wait: const Duration(milliseconds: 600),
      verify: (bloc) {},
    );
    blocTest<Feature1EditBloc, Feature1EditState>(
      'should emit [initial, with the new registered] for registered change',
      build: () => Feature1EditBloc(repo, testFeature1),
      act: (bloc) => bloc.add(const Feature1EditEventRegisteredChanged(true)),
      expect: () => [
        Feature1EditState(feature1: testFeature1, firstName: 'testString', lastName: 'testString', registered: true, age: 1, ),
      ],
      wait: const Duration(milliseconds: 600),
      verify: (bloc) {},
    );
    blocTest<Feature1EditBloc, Feature1EditState>(
      'should emit [initial, with the new age] for age change',
      build: () => Feature1EditBloc(repo, testFeature1),
      act: (bloc) => bloc.add(const Feature1EditEventAgeChanged(1)),
      expect: () => [
        Feature1EditState(feature1: testFeature1, firstName: 'testString', lastName: 'testString', registered: true, age: 1, ),
      ],
      wait: const Duration(milliseconds: 600),
      verify: (bloc) {},
    );

    blocTest<Feature1EditBloc, Feature1EditState>(
      'should emit [initial, success] when submitting the entity we are editing',
      build: () {
        registerFallbackValue(MockFeature1());
        when(() => repo.update(any())).thenAnswer((_) async {});
        return Feature1EditBloc(repo, testFeature1);
      },
      act: (bloc) => bloc.add(Feature1EditEventSubmitted()),
      expect: () => [
        isA<Feature1EditState>(),
      ],
      wait: const Duration(milliseconds: 600),
      verify: (bloc) {},
    );

    blocTest<Feature1EditBloc, Feature1EditState>(
      'should emit [initial, success] when submitting',
      build: () {
        registerFallbackValue(MockFeature1());
        when(() => repo.create(any())).thenAnswer((_) async {});
        return Feature1EditBloc(repo);
      },
      act: (bloc) => bloc.add(Feature1EditEventSubmitted()),
      expect: () => [
        isA<Feature1EditState>(),
      ],
      wait: const Duration(milliseconds: 600),
      verify: (bloc) {},
    );

    blocTest<Feature1EditBloc, Feature1EditState>(
      'should emit [initial, success] when deleting the entity we are editing',
      build: () {
        registerFallbackValue(MockFeature1());
        when(() => repo.delete(any())).thenAnswer((_) async {});
        return Feature1EditBloc(repo, testFeature1);
      },
      act: (bloc) => bloc.add(Feature1EditEventDelete()),
      expect: () => [
        isA<Feature1EditState>(),
      ],
      wait: const Duration(milliseconds: 600),
      verify: (bloc) {},
    );
  });

  group( 'equatable events', () {
    test('property event submitted', () async {
      Feature1EditEventSubmitted testEvent = Feature1EditEventSubmitted();
      expect(testEvent.props.length, equals(0));
      expect(testEvent, equals(testEvent));
    });
    test('property event deleted', () async {
      Feature1EditEventDelete testEvent = Feature1EditEventDelete();
      expect(testEvent.props.length, equals(0));
      expect(testEvent, equals(testEvent));
    });

    
    test('property event firstName', () async {
      Feature1EditEventFirstNameChanged testFirstNameEvent = const Feature1EditEventFirstNameChanged('testString');
      expect(testFirstNameEvent.props.length, equals(1));
      expect(testFirstNameEvent, equals(testFirstNameEvent));
    });
    
    test('property event lastName', () async {
      Feature1EditEventLastNameChanged testLastNameEvent = const Feature1EditEventLastNameChanged('testString');
      expect(testLastNameEvent.props.length, equals(1));
      expect(testLastNameEvent, equals(testLastNameEvent));
    });
    
    test('property event registered', () async {
      Feature1EditEventRegisteredChanged testRegisteredEvent = const Feature1EditEventRegisteredChanged(true);
      expect(testRegisteredEvent.props.length, equals(1));
      expect(testRegisteredEvent, equals(testRegisteredEvent));
    });
    
    test('property event age', () async {
      Feature1EditEventAgeChanged testAgeEvent = const Feature1EditEventAgeChanged(1);
      expect(testAgeEvent.props.length, equals(1));
      expect(testAgeEvent, equals(testAgeEvent));
    });
    
  });
}
