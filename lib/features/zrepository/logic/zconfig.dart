class ZConfig{
  //SingleTon
    ZConfig._();
    static final ZConfig _instance = ZConfig._();
    factory ZConfig() => ZConfig._instance;
  //

  Map<String, dynamic> supported = {};
   
  /// It sets the configs for the instance of the plugin.
  /// 
  /// Args:
  ///   configs (Map<String, dynamic>): A map of the configuration parameters.
  Future<void> setInstanceConfigs(Map<String, dynamic> configs) async {supported = configs;}
}