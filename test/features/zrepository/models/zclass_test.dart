// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable, override_on_non_overriding_member
import 'dart:convert';
import 'package:zrepository/features/zrepository/models/zclass.dart';


abstract class ZclassTestEntity extends ZClass {
  final String name;

  ZclassTestEntity({
    super.uuid,
    required this.name,
  });

  @override
  List<Object> get props => [uuid ?? '', name];
}


class ZclassTestModel extends ZclassTestEntity {
  ZclassTestModel({required super.name, super.uuid});

  ZclassTestModel copyWith({
    String? uuid,
    String? name,
  }) {
    return ZclassTestModel(
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uuid': uuid,
      'name': name,
    };
  }

  factory ZclassTestModel.fromMap(Map<String, dynamic> map) {
    return ZclassTestModel(
      uuid: map['uuid'] as String?,
      name: map['name'] as String,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory ZclassTestModel.fromJson(String source) => ZclassTestModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;
}
