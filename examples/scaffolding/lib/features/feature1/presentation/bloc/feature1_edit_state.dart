part of 'feature1_edit_bloc.dart';

enum Feature1EditStatus { initial, loading, success, failure }

class Feature1EditState extends Equatable {
  final Feature1EditStatus status;
  final Feature1? feature1;
  final String firstName;
  final String lastName;
  final bool registered;
  final int age;
  
  const Feature1EditState({
    this.status = Feature1EditStatus.initial,
    this.feature1, 
    required this.firstName,
    required this.lastName,
    required this.registered,
    required this.age,
  });

  @override
  List<Object?> get props => [status, feature1, firstName, lastName, registered, age, ];

  Feature1EditState copyWith({
    Feature1EditStatus? status, 
    Feature1? initialFeature1,
    String? firstName, 
    String? lastName, 
    bool? registered, 
    int? age, 
  }) {
    return Feature1EditState(
      status: status ?? this.status,
      feature1: initialFeature1 ?? feature1, 
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      registered: registered ?? this.registered,
      age: age ?? this.age,
    );
  }
}
