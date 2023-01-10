part of 'feature1_edit_bloc.dart';

abstract class Feature1EditEvent extends Equatable {
  const Feature1EditEvent();
}

class Feature1EditEventFirstNameChanged extends Feature1EditEvent {
  final String firstName;
  const Feature1EditEventFirstNameChanged(this.firstName,);

  @override
  List<Object?> get props => [firstName];
}

class Feature1EditEventLastNameChanged extends Feature1EditEvent {
  final String lastName;
  const Feature1EditEventLastNameChanged(this.lastName,);

  @override
  List<Object?> get props => [lastName];
}

class Feature1EditEventRegisteredChanged extends Feature1EditEvent {
  final bool registered;
  const Feature1EditEventRegisteredChanged(this.registered,);

  @override
  List<Object?> get props => [registered];
}

class Feature1EditEventAgeChanged extends Feature1EditEvent {
  final int age;
  const Feature1EditEventAgeChanged(this.age,);

  @override
  List<Object?> get props => [age];
}

class Feature1EditEventSubmitted extends Feature1EditEvent {
  @override
  List<Object?> get props => [];
}

class Feature1EditEventDelete extends Feature1EditEvent {
  @override
  List<Object?> get props => [];
}