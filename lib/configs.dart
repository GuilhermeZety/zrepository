class Zconfig{
  //SingleTon
    Zconfig._();
    static final Zconfig _instance = Zconfig._();
    factory Zconfig() => Zconfig._instance;

    Map<String, dynamic> suportable = {};

    /// Same
    /// {
    ///   Person: Person.fromMap,
    /// }
    ///
    ///
    Future<void> setInstanceConfigs(Map<String, dynamic> configs) async {
      suportable = configs;
    }
  ///

}