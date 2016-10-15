class profile::apps::rgbank(
  $db_host = 'localhost',
  $db_name = 'wordpress',
  $db_user = 'wordpress',
  $db_pass = 'password',
  $docroot = '/var/www/rgbank',
){

  file { "/var/lib/${db_name}":
    ensure => directory,
    mode   => '0755',
  }

  staging::file { "${db_name}.sql":
    source => 'https://raw.githubusercontent.com/puppetlabs/rgbank/master/rgbank.sql',
    target => "/var/lib/${db_name}/rgbank.sql",
    before => Mysql::Db[$db_name],
  }

  mysql::db { $db_name:
    user     => $db_user,
    password => $db_pass,
    host     => '%',
    sql      => "/var/lib/${db_name}/rgbank.sql",
  }

  mysql_user { "${db_user}@localhost":
    ensure        => 'present',
    password_hash => mysql_password($db_pass),
    require       => Mysql::Db[$db_name],
  }

  class {'::profile::apps::wordpress':
    manage_db => false,
    docroot   => $docroot,
  }

  file { "${docroot}/wp-content/uploads":
    ensure  => directory,
    owner   => $::apache::user,
    group   => $::apache::user,
    recurse => true,
    require => Class['::wordpress'],
  }

  file {"${docroot}/wp-content/themes/rgbank":
    ensure  => directory,
    require => Class['::wordpress'],
    before  => Staging::Deploy['theme_rgbank.tgz'],
  }

  staging::deploy { 'theme_rgbank.tgz':
    source  => 'https://github.com/puppetlabs/rgbank/archive/master.zip',
    target  => "${docroot}/wp-content/themes/rgbank",
    creates => "${docroot}/wp-content/themes/rgbank/index.php",
    notify  => Service['httpd'],
  }
}
