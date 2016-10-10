class profile::base::motd (
  String $message = 'Welcome to the demo enviornment network!/n',
){

  class { 'motd':
      content => $message,
  }

}
