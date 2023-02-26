// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
abstract class MyClass extends Equatable {
  String? id;

  MyClass({
    required this.id,
  });

  Map<String, dynamic> toMap();

  MyClass copyWith();

  String toJson() => jsonEncode(toMap());
  Map<String, dynamic> toMapWith(Map<String, dynamic> map) => {...toMap(), ...map};

  @override
  bool? get stringify => true;
}