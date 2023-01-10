import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class Feature1 extends Equatable {
  final String id;
  final DateTime created;
  final DateTime modified;

   final String firstName;
   final String lastName;
   final bool registered;
   final int age;
  
  Feature1({ 
    String? id,
    DateTime? created,
    DateTime? modified,
    required this.firstName,
    required this.lastName,
    required this.registered,
    required this.age,
  }) : id = id ?? const Uuid().v4(),
       created = created ?? DateTime.now(),
       modified = modified ?? DateTime.now();

  @override
  List<Object> get props => [id, created, modified,  firstName, lastName, registered, age, ];

  @override
  String toString() {
    return '(id: $id,  firstName: $firstName, lastName: $lastName, registered: $registered, age: $age, )';
  }

  Feature1 copyWith({ 
    String? id,
    DateTime? created,
    DateTime? modified,
    String? firstName,
    String? lastName,
    bool? registered,
    int? age,
  }) {
    return Feature1( 
      id: id ?? this.id,
      created: created ?? DateTime.now(),
      modified: modified ?? DateTime.now(),
      firstName : firstName ?? this.firstName,
      lastName : lastName ?? this.lastName,
      registered : registered ?? this.registered,
      age : age ?? this.age,
    );
  }
}