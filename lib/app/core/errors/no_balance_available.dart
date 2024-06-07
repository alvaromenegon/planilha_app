class NoBalanceAvailable extends Error{
  final String message;
  NoBalanceAvailable({this.message = 'No balance available'});
}