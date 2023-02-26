class Configs{
  //SingleTon
    Configs._();
    static final Configs _instance = Configs._();
    factory Configs() => Configs._instance;

    Map<String, dynamic> suportable = {};

    /// Same
    /// {
    ///   'Person': Person.fromMap,
    /// }
    ///
    ///
    Future<void> setInstanceConfigs(Map<String, dynamic> configs) async {
      suportable = configs;
    }
  ///

}