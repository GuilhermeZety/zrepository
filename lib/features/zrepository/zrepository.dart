// ignore_for_file: prefer_final_fields

library zrepository;

import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:zrepository/features/zrepository/errors/not_instances_config_exception.dart';

import 'package:zrepository/features/zrepository/logic/zconfig.dart';
import 'package:zrepository/features/zrepository/models/zclass.dart';
export 'package:zrepository/features/zrepository/logic/zconfig.dart';
export 'package:zrepository/features/zrepository/models/zclass.dart';

class ZRepository{
  static ZConfig configs = ZConfig();
  /// > It takes a map of types to functions that create instances of those types, and sets the map of
  /// type names to functions that create instances of those types
  /// 
  /// Args:
  ///   instances (Map<Type, ZClass Function(Map<String, dynamic>)>): A map of the classes you want to
  /// be able to deserialize. The key is the class type, and the value is a function that takes a map of
  /// the json data and returns an instance of the class.
  static setInstances(Map<Type, ZClass Function(Map<String, dynamic>)> instances) {
    configs.setInstanceConfigs(instances.map((key, value) => MapEntry(key.toString(), value)));
  }

  /// It checks if the instances are set.
  static void verifyInstances() { 
    if(configs.supported.isEmpty) throw NotInstancesConfigException('You need to set the instances before use the zrepository');
  }
  /* -------------------------------------------------------------------------- */
  /*                                    ADD                                     */
  /* -------------------------------------------------------------------------- */
      /* -------------------------------- SAVE ONE -------------------------------- */
     /// It saves the object to the shared preferences.
     /// 
     /// Args:
     ///   key (String): The key to save the object under.
     ///   object (ZClass): The object to be saved.
     /// 
     /// Returns:
     ///   A Future<bool>
      static Future<bool> save({required String key, required ZClass object}) async {
        verifyInstances();
        return (await StreamingSharedPreferences.instance).setString(key, object.toJson());
      }

      /* -------------------------------- SAVE LIST ------------------------------- */
     /// It saves a list of objects to the shared preferences.
     /// 
     /// Args:
     ///   key (String): The key to save the list under.
     ///   list (List<ZClass>): The list of objects to save.
     /// 
     /// Returns:
     ///   A Future<bool>
      static Future<bool> saveList({
        required String key, 
        required List<ZClass> list
      }) async {
        verifyInstances();
        return (await StreamingSharedPreferences.instance).setStringList(key, list.map((e) {
          e.uuid ??= const Uuid().v4();
          return e.toJson();
        }).toList());
      }

      /* ----------------------------- ADD ONE IN LIST ---------------------------- */
     /// It adds an object to a list.
     /// 
     /// Args:
     ///   key (String): The key that will be used to save the list.
     ///   object (T): The object you want to add to the list.
     /// 
     /// Returns:
     ///   A Future<bool>
      static Future<bool> addInList<T extends ZClass>({
        required String key, 
        required T object
      }) async {
        verifyInstances();
        if(T.toString() == 'MyClass') throw Exception('You can\'t add a MyClass object in a list. Use a class that extends MyClass');
        List<T>? itens = await getList<T>(key);
        
        itens ??= [];

        object.uuid ??= const Uuid().v4();
        itens.add(object);
        return saveList(key: key, list: itens);
      }
  /* ----------------------------------- ... ---------------------------------- */



  /* -------------------------------------------------------------------------- */
  /*                                     GET                                    */
  /* -------------------------------------------------------------------------- */
      /* --------------------------------- GET ONE -------------------------------- */
     /// It gets the object from the shared preferences.
     /// 
     /// Args:
     ///   key (String): The key to store the object in.
     /// 
     /// Returns:
     ///   A Future<T?>
      static Future<T?> get<T extends ZClass>(String key) async {
        verifyInstances();
        if(T.toString() == 'MyClass') throw Exception('You can\'t add a MyClass object in a list. Use a class that extends MyClass');
        Object? object = (await StreamingSharedPreferences.instance).getString(key, defaultValue: '');
        
        if(object == '' || !ZConfig().supported.containsKey(T.toString())) return null;

        return configs.supported[T.toString()](jsonDecode(object as String));
      }

      /* -------------------------------- GET LIST -------------------------------- */
     /// It gets a list of objects from the shared preferences
     /// 
     /// Args:
     ///   key (String): The key to store the list in.
     /// 
     /// Returns:
     ///   A list of objects of type T.
      static Future<List<T>?> getList<T extends ZClass>(String key) async {
        verifyInstances();
        if(T.toString() == 'MyClass') throw Exception('You can\'t add a MyClass object in a list. Use a class that extends MyClass');
        if(!configs.supported.containsKey(T.toString())) throw Exception('Dont suport this type');
        
        var list = (await StreamingSharedPreferences.instance).getStringList(key, defaultValue: []);
        

        return list.getValue().map<T>((e) => configs.supported[T.toString()](jsonDecode(e))).toList();
      }
  /* ----------------------------------- ... ---------------------------------- */



  /* -------------------------------------------------------------------------- */
  /*                                   REMOVE                                   */
  /* -------------------------------------------------------------------------- */
      /* ------------------------------- REMOVE ONE ------------------------------- */
     /// It removes an item from a list
     /// 
     /// Args:
     ///   key (String): The key that will be used to save the list.
     ///   item (T): The item you want to remove from the list.
     /// 
     /// Returns:
     ///   A Future<bool>
      static Future<bool> removeEpecific<T extends ZClass>(String key, {required T item}) async {
        verifyInstances();
        if(T.toString() == 'MyClass') throw Exception('You can\'t add a MyClass object in a list. Use a class that extends MyClass');
        var itens = await getList<T>(key);

        if(itens == null || itens.isEmpty) return false;

        itens.removeWhere((element) => element.uuid == item.uuid);

        return saveList(key: key, list: itens);
      }

      /* ---------------------------------- CLEAN --------------------------------- */
      /// It removes the value associated with the key from the shared preferences
      /// 
      /// Args:
      ///   key (String): The key of the preference you want to retrieve.
      static Future<bool> clean(String key) async => (await StreamingSharedPreferences.instance).remove(key);
  /* ----------------------------------- ... ---------------------------------- */

  /* -------------------------------------------------------------------------- */
  /*                                   STREAM                                   */
  /* -------------------------------------------------------------------------- */
 /// It returns a stream of a list of objects of type T
 /// 
 /// Args:
 ///   key (String): The key to store the list in.
 /// 
 /// Returns:
 ///   A stream of a list of objects of type T.
  static Future<Stream<List<T>>> stream<T extends ZClass>(String key) async {
    verifyInstances();
    if(T.toString() == 'MyClass') throw Exception('You can\'t add a MyClass object in a list. Use a class that extends MyClass');
    var p = (await StreamingSharedPreferences.instance).getStringList(key, defaultValue: []);

    final fromMap = configs.supported[T.toString()];

    if(configs.supported[T.toString()] == null) throw Exception('This class is not suportable');

    return p.map((event) => event.map<T>((e) => fromMap(jsonDecode(e))).toList());
  }
  /* ----------------------------------- ... ---------------------------------- */
}