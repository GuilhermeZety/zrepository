import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zrepository/features/zrepository/errors/not_instances_config_exception.dart';
import 'package:zrepository/zrepository.dart';

import 'models/zclass_test.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
   group('Test ZRepository:', () {
    final instances = {
      ZclassTestModel: ZclassTestModel.fromMap,
    };
    test('verify setInstances;', () {
      expect(ZRepository.configs.supported, {});

      ZRepository.setInstances(instances);

      expect(ZRepository.configs.supported, instances.map((key, value) => MapEntry(key.toString(), value)));
    });

    test('verify verifyInstances;', () {
      if(ZRepository.configs.supported.isNotEmpty) ZRepository.configs.supported.clear();

      expect(() => ZRepository.verifyInstances(), throwsA(isA<NotInstancesConfigException>()));

      ZRepository.setInstances(instances);

      expect(ZRepository.configs.supported, instances.map((key, value) => MapEntry(key.toString(), value)));
    });

  });
}

