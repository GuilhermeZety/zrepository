// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
abstract class ZClass<T> extends Equatable with ZClassExtends{
  String? id;

  ZClass({
    required this.id,
  });

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [];
}

mixin ZClassExtends{
  String toJson() => throw UnimplementedError();
  Map<String, dynamic> toMap() => throw UnimplementedError();
  copyWith() => throw UnimplementedError();
}