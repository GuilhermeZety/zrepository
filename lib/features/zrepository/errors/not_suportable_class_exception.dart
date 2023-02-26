class NotSuportableClassException implements Exception{
  final String message;
  NotSuportableClassException({this.message = 'This class is not suportable'});
}