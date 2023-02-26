// ignore_for_file: prefer_final_fields

library zrepository;

import 'dart:convert';

import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:zrepository/configs.dart';
import 'package:zrepository/zclass.dart';

class ZRepository{
  static Zconfig configs = Zconfig();
  static setInstances(Map<Type, ZClass Function(Map<String, dynamic>)> instances) {
    configs.setInstanceConfigs(instances.map((key, value) => MapEntry(key.toString(), value)));
  }

  static void verifyInstances() { 
    try{
      if(configs.suportable.isEmpty) throw Exception('You need to set the instances before use the zrepository');
    }catch(error, stackTrace){
      Error.throwWithStackTrace(error, stackTrace);
    }
  }
  /* -------------------------------------------------------------------------- */
  /*                                    ADD                                     */
  /* -------------------------------------------------------------------------- */
      /* -------------------------------- SAVE ONE -------------------------------- */
      static Future<bool> save({required String key, required ZClass object}) async {
        verifyInstances();
        return (await StreamingSharedPreferences.instance).setString(key, object.toJson());
      }

      /* -------------------------------- SAVE LIST ------------------------------- */
      static Future<bool> saveList({
        required String key, 
        required List<ZClass> list
      }) async {
        verifyInstances();
        return (await StreamingSharedPreferences.instance).setStringList(key, list.map((e) {
          e.id ??= const Uuid().v4();
          return e.toJson();
        }).toList());
      }

      /* ----------------------------- ADD ONE IN LIST ---------------------------- */
      static Future<bool> addInList<T extends ZClass>({
        required String key, 
        required T object
      }) async {
        verifyInstances();
        if(T.toString() == 'MyClass') throw Exception('You can\'t add a MyClass object in a list. Use a class that extends MyClass');
        List<T>? itens = await getList<T>(key);
        
        itens ??= [];

        object.id ??= const Uuid().v4();
        itens.add(object);
        return saveList(key: key, list: itens);
      }
  /* ----------------------------------- ... ---------------------------------- */



  /* -------------------------------------------------------------------------- */
  /*                                     GET                                    */
  /* -------------------------------------------------------------------------- */
      /* --------------------------------- GET ONE -------------------------------- */
      static Future<T?> get<T extends ZClass>(String key) async {
        verifyInstances();
        if(T.toString() == 'MyClass') throw Exception('You can\'t add a MyClass object in a list. Use a class that extends MyClass');
        Object? object = (await StreamingSharedPreferences.instance).getString(key, defaultValue: '');
        
        if(object == '' || !Zconfig().suportable.containsKey(T.toString())) return null;

        return configs.suportable[T.toString()](jsonDecode(object as String));
      }

      /* -------------------------------- GET LIST -------------------------------- */
      static Future<List<T>?> getList<T extends ZClass>(String key) async {
        verifyInstances();
        if(T.toString() == 'MyClass') throw Exception('You can\'t add a MyClass object in a list. Use a class that extends MyClass');
        if(!configs.suportable.containsKey(T.toString())) throw Exception('Dont suport this type');
        
        var list = (await StreamingSharedPreferences.instance).getStringList(key, defaultValue: []);
        

        return list.getValue().map<T>((e) => configs.suportable[T.toString()](jsonDecode(e))).toList();
      }
  /* ----------------------------------- ... ---------------------------------- */



  /* -------------------------------------------------------------------------- */
  /*                                   REMOVE                                   */
  /* -------------------------------------------------------------------------- */
      /* ------------------------------- REMOVE ONE ------------------------------- */
      static Future<bool> removeEpecific<T extends ZClass>(String key, {required T item}) async {
        verifyInstances();
        if(T.toString() == 'MyClass') throw Exception('You can\'t add a MyClass object in a list. Use a class that extends MyClass');
        var itens = await getList<T>(key);

        if(itens == null || itens.isEmpty) return false;

        itens.removeWhere((element) => element.id == item.id);

        return saveList(key: key, list: itens);
      }

      /* ---------------------------------- CLEAN --------------------------------- */
      static Future<bool> clean(String key) async => (await StreamingSharedPreferences.instance).remove(key);
  /* ----------------------------------- ... ---------------------------------- */

  /* -------------------------------------------------------------------------- */
  /*                                   STREAM                                   */
  /* -------------------------------------------------------------------------- */
  Future<Stream<List<T>>> stream<T extends ZClass>(String key) async {
    verifyInstances();
    if(T.toString() == 'MyClass') throw Exception('You can\'t add a MyClass object in a list. Use a class that extends MyClass');
    var p = (await StreamingSharedPreferences.instance).getStringList(key, defaultValue: []);

    final fromMap = configs.suportable[T.toString()];

    if(configs.suportable[T.toString()] == null) throw Exception('This class is not suportable');

    return p.map((event) => event.map<T>((e) => fromMap(jsonDecode(e))).toList());
  }
  /* ----------------------------------- ... ---------------------------------- */
}