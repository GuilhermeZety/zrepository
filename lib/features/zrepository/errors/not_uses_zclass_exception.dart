class NotUsesZClassException implements Exception{
  final String message;
  NotUsesZClassException({this.message = 'You can\'t add a ZClass object in a list. Use a class that extends ZClass'});
}