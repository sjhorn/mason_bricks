import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:scaffolding_sample/features/feature1/feature1.dart';

part 'feature1_edit_event.dart';
part 'feature1_edit_state.dart';

class Feature1EditBloc extends Bloc<Feature1EditEvent, Feature1EditState> {
  final Feature1Repository _repo;
  Feature1EditBloc(this._repo, [Feature1? entity])
      : super(Feature1EditState(
          feature1: entity, 
          firstName: entity?.firstName ?? '',
          lastName: entity?.lastName ?? '',
          registered: entity?.registered ?? false,
          age: entity?.age ?? 0,
        )) {
    on<Feature1EditEventFirstNameChanged>(_firstNameChanged);
    on<Feature1EditEventLastNameChanged>(_lastNameChanged);
    on<Feature1EditEventRegisteredChanged>(_registeredChanged);
    on<Feature1EditEventAgeChanged>(_ageChanged);
    on<Feature1EditEventSubmitted>(_submitted);
    on<Feature1EditEventDelete>(_delete);
  }
    
  FutureOr<void> _firstNameChanged(
      Feature1EditEventFirstNameChanged event, Emitter<Feature1EditState> emit) async {
    emit(state.copyWith(firstName: event.firstName));
  }   
  FutureOr<void> _lastNameChanged(
      Feature1EditEventLastNameChanged event, Emitter<Feature1EditState> emit) async {
    emit(state.copyWith(lastName: event.lastName));
  }   
  FutureOr<void> _registeredChanged(
      Feature1EditEventRegisteredChanged event, Emitter<Feature1EditState> emit) async {
    emit(state.copyWith(registered: event.registered));
  }   
  FutureOr<void> _ageChanged(
      Feature1EditEventAgeChanged event, Emitter<Feature1EditState> emit) async {
    emit(state.copyWith(age: event.age));
  } 


  FutureOr<void> _submitted(
      Feature1EditEventSubmitted event, Emitter<Feature1EditState> emit) async {
    Feature1 entity;
    if (state.feature1 == null) {
      entity = Feature1(firstName: state.firstName,lastName: state.lastName,registered: state.registered,age: state.age,);
      await _repo.create(entity);
    } else {
      entity = state.feature1!.copyWith(
        firstName: state.firstName,
        lastName: state.lastName,
        registered: state.registered,
        age: state.age,
      );
      await _repo.update(entity);
    }
    emit(state.copyWith(initialFeature1: entity, status: Feature1EditStatus.success));
  }

  FutureOr<void> _delete(
      Feature1EditEventDelete event, Emitter<Feature1EditState> emit) async {
    await _repo.delete(state.feature1!);
    emit(state.copyWith(initialFeature1: state.feature1!, status: Feature1EditStatus.success));
  }
}
