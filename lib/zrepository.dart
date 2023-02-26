// ignore_for_file: prefer_final_fields

library zrepository;

import 'dart:convert';

import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:zrepository/configs.dart';
import 'package:zrepository/my_class.dart';

class ZRepository{
  static setInstances(Map<String, dynamic> instances) => Configs().setInstanceConfigs(instances);

  /* -------------------------------------------------------------------------- */
  /*                                    ADD                                     */
  /* -------------------------------------------------------------------------- */
      /* -------------------------------- SAVE ONE -------------------------------- */
      static Future<bool> save({required String key, required MyClass object}) async {
        return (await StreamingSharedPreferences.instance).setString(key, object.toJson());
      }

      /* -------------------------------- SAVE LIST ------------------------------- */
      static Future<bool> saveList({
        required String key, 
        required List<MyClass> list
      }) async => (await StreamingSharedPreferences.instance).setStringList(key, list.map((e) {
        e.id ??= const Uuid().v4();
        return e.toJson();
      }).toList());

      /* ----------------------------- ADD ONE IN LIST ---------------------------- */
      static Future<bool> addInList<T extends MyClass>({
        required String key, 
        required T object
      }) async {
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
      static Future<T?> get<T extends MyClass>(String key) async {
        Object? object = (await StreamingSharedPreferences.instance).getString(key, defaultValue: '');
        
        if(object == '' || !Configs().suportable.containsKey(T.toString())) return null;

        return Configs().suportable[T.toString()](jsonDecode(object as String));
      }

      /* -------------------------------- GET LIST -------------------------------- */
      static Future<List<T>?> getList<T extends MyClass>(String key) async {
        var list = (await StreamingSharedPreferences.instance).getStringList(key, defaultValue: []);
        
        if(!Configs().suportable.containsKey(T.toString())) return null;

        return list.getValue().map<T>((e) => Configs().suportable[T.toString()](jsonDecode(e))).toList();
      }
  /* ----------------------------------- ... ---------------------------------- */



  /* -------------------------------------------------------------------------- */
  /*                                   REMOVE                                   */
  /* -------------------------------------------------------------------------- */
      /* ------------------------------- REMOVE ONE ------------------------------- */
      static Future<bool> removeEpecific<T extends MyClass>(String key, {required T item}) async {
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
  Future<Stream<List<T>>> stream<T extends MyClass>(String key) async {
    var p = (await StreamingSharedPreferences.instance).getStringList(key, defaultValue: []);

    final fromMap = Configs().suportable[T.toString()];

    if(Configs().suportable[T.toString()] == null) throw Exception('This class is not suportable');

    return p.map((event) => event.map<T>((e) => fromMap(jsonDecode(e))).toList());
  }
  /* ----------------------------------- ... ---------------------------------- */
}