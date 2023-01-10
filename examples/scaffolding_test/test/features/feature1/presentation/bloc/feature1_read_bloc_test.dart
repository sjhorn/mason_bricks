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
    when(() => repo.readMore(true)).thenAnswer((_) async => controller.sink
        .add(Feature1ChangeInfo(type: Feature1ChangeType.read, feature1s: [testFeature1])));

    //feature1Bloc = Feature1ReadBloc(repo);
  });
  group('feature1s bloc', () {
    blocTest<Feature1ReadBloc, Feature1ReadState>(
      'should emit [loading, success] for successful data load',
      build: () => Feature1ReadBloc(repo),
      act: (bloc) {},
      expect: () => [
        Feature1ReadStateLoading(),
        Feature1ReadStateSuccess(feature1s: [testFeature1]),
      ],
      wait: const Duration(milliseconds: 600),
      verify: (bloc) {
        verify(() => repo.read()).called(1);
      },
    );

    blocTest<Feature1ReadBloc, Feature1ReadState>(
      'should emit [loading, failure] for unsuccessful data load',
      build: () {
        when(() => repo.readMore(true))
            .thenAnswer((_) async => controller.sink.addError('failed'));
        return Feature1ReadBloc(repo);
      },
      act: (bloc) {},
      expect: () => [
        Feature1ReadStateLoading(),
        const Feature1ReadStateFailure(message: 'failed'),
      ],
      wait: const Duration(milliseconds: 600),
      verify: (bloc) {
        verify(() => repo.read()).called(1);
      },
    );

    blocTest<Feature1ReadBloc, Feature1ReadState>(
      'should emit [loading, create, success] after create',
      build: () {
        registerFallbackValue(MockFeature1());
        when(() => repo.create(any())).thenAnswer((_) async {
          controller.add(
              Feature1ChangeInfo(type: Feature1ChangeType.create, feature1s: [testFeature1]));
        });
        return Feature1ReadBloc(repo);
      },
      act: (bloc) => bloc.add(const Feature1ReadEventCreate()),
      expect: () => [
        Feature1ReadStateLoading(),
        isA<Feature1ReadStateSuccess>(),
        Feature1ReadStateCreate(selectedFeature1: testFeature1),
      ],
      wait: const Duration(milliseconds: 600),
      verify: (bloc) {
        verify(() => repo.create(any())).called(1);
      },
    );

    blocTest<Feature1ReadBloc, Feature1ReadState>(
      'should emit [loading, delete, success] after delete',
      build: () {
        registerFallbackValue(MockFeature1());
        when(() => repo.delete(any())).thenAnswer((args) async {
          Feature1 feature1 = args.positionalArguments[0];
          controller.add(
              Feature1ChangeInfo(type: Feature1ChangeType.delete, feature1s: [feature1]));
        });
        return Feature1ReadBloc(repo);
      },
      act: (bloc) => bloc.add(Feature1ReadEventDelete(testFeature1)),
      expect: () => [
        Feature1ReadStateLoading(),
        isA<Feature1ReadStateSuccess>(),
        Feature1ReadStateDelete(selectedFeature1: testFeature1),
      ],
      wait: const Duration(milliseconds: 600),
      verify: (bloc) {
        verify(() => repo.delete(any())).called(1);
      },
    );

    blocTest<Feature1ReadBloc, Feature1ReadState>(
      'should emit [loading, update, success] after delete',
      build: () {
        registerFallbackValue(MockFeature1());
        when(() => repo.update(any())).thenAnswer((args) async {
          Feature1 feature1 = args.positionalArguments[0];
          controller.add(
              Feature1ChangeInfo(type: Feature1ChangeType.update, feature1s: [feature1]));
        });
        return Feature1ReadBloc(repo);
      },
      act: (bloc) => bloc.add(Feature1ReadEventUpdate(testFeature1)),
      expect: () => [
        Feature1ReadStateLoading(),
        isA<Feature1ReadStateSuccess>(),
        Feature1ReadStateUpdate(selectedFeature1: testFeature1),
      ],
      wait: const Duration(milliseconds: 600),
      verify: (bloc) {
        verify(() => repo.update(any())).called(1);
      },
    );

    blocTest<Feature1ReadBloc, Feature1ReadState>(
      'should emit [loading, success] after readMore',
      build: () {
        when(() => repo.readMore()).thenAnswer((args) async {
          controller.add(
            Feature1ChangeInfo(
                type: Feature1ChangeType.read, feature1s: [testFeature1], totalCount: 1),
          );
        });
        return Feature1ReadBloc(repo);
      },
      act: (bloc) => bloc.add(const Feature1ReadEventReadMore()),
      expect: () => [
        Feature1ReadStateLoading(),
        Feature1ReadStateSuccess(feature1s: [testFeature1]),
        Feature1ReadStateSuccess(feature1s: [testFeature1], totalCount: 1),
      ],
      wait: const Duration(milliseconds: 600),
      verify: (bloc) {
        verify(() => repo.readMore(true)).called(1);
        verify(() => repo.readMore()).called(1);
      },
    );
  });
}
