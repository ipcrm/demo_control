class profile::base::motd (
  String $message = 'Welcome to the demo enviornment network!/n',
){

  case $::facts['os']['name'] {
    'Windows': {

      registry_value { '32:HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\policies\system\legalnoticecaption':
        ensure => present,
        type   => string,
        data   => 'Message of the day',
      }

      registry_value { '32:HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\policies\system\legalnoticetext':
        ensure => present,
        type   => string,
        data   => $message,
      }

    }

    default: {
      class { 'motd':
          content => $message,
      }
    }

  }

}
