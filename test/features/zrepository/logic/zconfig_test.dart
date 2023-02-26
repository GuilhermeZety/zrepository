import 'package:flutter_test/flutter_test.dart';
import 'package:zrepository/features/zrepository/logic/zconfig.dart';

void main() {
  Map<String, dynamic> instances = {
    'Test': 'Test'
  };

  group('Test ZConfig: ', () {

    test('verify setting supported values;', () {
      ZConfig zconfig = ZConfig();
      expect(zconfig.supported, {});

      zconfig.setInstanceConfigs(instances);

      expect(zconfig.supported, instances);
    });

    test('verify singleton from zconfig;', () {
      if(ZConfig().supported != instances){
        ZConfig zconfigFirst = ZConfig();
        expect(zconfigFirst.supported, {});

        zconfigFirst.setInstanceConfigs(instances);

        expect(zconfigFirst.supported, instances);

        ZConfig zconfigSecond = ZConfig();

        expect(zconfigSecond.supported, instances);
      }
    });
  });
}