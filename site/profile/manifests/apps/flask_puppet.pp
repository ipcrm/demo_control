class profile::apps::flask_puppet (
  $dist_file,
){

  package{'python-pip':
    ensure  => present,
  } ->

  file {['/var/www', '/var/www/flask']:
    ensure => directory,
    mode   => '0755',
  } ->

  file {'/var/www/flask/wsgi.py':
    ensure => present,
    mode   => '0755',
    source => 'puppet:///modules/profiles/flask_puppet/wsgi.py',
  } ->

  apache::vhost { $::fqdn:
    port                        => '80',
    docroot                     => '/var/www/flask',
    wsgi_application_group      => '%{GLOBAL}',
    wsgi_daemon_process         => 'wsgi',
    wsgi_daemon_process_options => {
      processes    => '2',
      threads      => '15',
      display-name => '%{GROUP}',
    },
    wsgi_import_script          => '/var/www/flask/wsgi.py',
    wsgi_import_script_options  => {
      process-group     => 'wsgi',
      application-group => '%{GLOBAL}',
    },
    wsgi_process_group          => 'wsgi',
    wsgi_script_aliases         => {
      '/' => '/var/www/flask/wsgi.py',
    },
  }

  remote_file { 'flask_puppet.tar.gz':
    ensure  => latest,
    path    => '/var/tmp/flask_puppet.tar.gz',
    source  => $dist_file,
    notify  => Exec['pip install flask_puppet'],
    require => [ Class['apache'], Apache::Vhost[$::fqdn] ],
  }

  exec { 'pip install flask_puppet':
    refreshonly => true,
    path        => '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin',
    command     => 'pip install /var/tmp/flask_puppet.tar.gz --upgrade',
    notify      => Service['httpd'],
    require     => Remote_file['flask_puppet.tar.gz'],
  }

}
