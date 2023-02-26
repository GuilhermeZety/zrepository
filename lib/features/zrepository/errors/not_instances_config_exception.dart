class NotInstancesConfigException implements Exception{
  final String message;
  NotInstancesConfigException({this.message = 'You need to set the instances before use the zrepository'});
}