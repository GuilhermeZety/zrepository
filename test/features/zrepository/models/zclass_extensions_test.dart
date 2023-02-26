import 'package:flutter_test/flutter_test.dart';
import '../models/zclass_test.dart';
import 'package:zrepository/features/zrepository/models/zclass_extensions.dart';

void main() {
  late ZclassTestEntity model;

  setUp(() {
    model = ZclassTestModel(name: 'name');
  });
  group('Test AS extension: ', () { 
    test('verify change ty functionality;', () {
      final modelResult = model.as<ZclassTestModel>();
      expect(modelResult.runtimeType, ZclassTestModel);
    });
  });
}