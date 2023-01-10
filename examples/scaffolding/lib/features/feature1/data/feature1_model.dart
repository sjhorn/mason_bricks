import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import 'package:scaffolding_sample/features/feature1/feature1.dart';

class Feature1Model extends Equatable {
  final String id;
  final DateTime created;
  final DateTime modified;
  final String firstName;
  final String lastName;
  final bool registered;
  final int age;
  
  Feature1Model({ 
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

  Feature1 toFeature1() {
    return Feature1( 
      id: id, 
      created: created, 
      modified: modified, 
      firstName: firstName,
      lastName: lastName,
      registered: registered,
      age: age,    
    );
  }

  static Feature1Model fromFeature1(Feature1 feature1) {
    return Feature1Model( 
      id: feature1.id, 
      created: feature1.created, 
      modified: feature1.modified, 
      firstName: feature1.firstName,
      lastName: feature1.lastName,
      registered: feature1.registered,
      age: feature1.age, 
    );
  }

  Map<String, dynamic> toMap() {
    return { 
     'firstName': firstName,
     'lastName': lastName,
     'registered': registered,
     'age': age, 
    };
  }

  factory Feature1Model.fromMap(Map<String, dynamic> map) {
    return Feature1Model(
     firstName: map['firstName'],
     lastName: map['lastName'],
     registered: map['registered'],
     age: map['age'], 
    );
  }

  String toJson() => json.encode(toMap());

  factory Feature1Model.fromJson(String source) =>
    Feature1Model.fromMap(json.decode(source));

  @override
  List<Object> get props => [ firstName, lastName, registered, age, ];

}