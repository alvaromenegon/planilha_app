class NoBalanceAvailable extends Error{
  final String message;
  NoBalanceAvailable({this.message = 'No balance available'});
}

class InvalidBackup extends Error{
  final String message;
  InvalidBackup({this.message = 'File is not a valid backup file'});
}

class InvalidLine extends Error{
  final String message;
  InvalidLine({this.message = 'Uma das linhas do arquivo não é válida e foi ignorada.'});
}