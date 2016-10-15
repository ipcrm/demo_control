class profile::database::mysql (
  $java_enable     = false,
  $perl_enable     = false,
  $php_enable      = true,
  $python_enable   = false,
){
  class { '::mysql::server':
    override_options => {
      'mysqld' => {
        'bind-address' => '0.0.0.0',
      },
    },
  }

  class{'::mysql::bindings':
    java_enable   => $java_enable,
    perl_enable   => $perl_enable,
    php_enable    => $php_enable,
    python_enable => $python_enable,
  }
}
