// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable


import 'dart:convert';

import 'package:equatable/equatable.dart';

/// It is the base class for all the models.
abstract class ZClass extends Equatable{
  String? uuid;

  ZClass({
    required this.uuid,
  });
  
  Map<String, dynamic> toMap();

  @override
  bool get stringify => true;

  String toJson() => jsonEncode(toMap());
}
