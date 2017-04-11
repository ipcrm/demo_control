class profile::master::fileserver {

  apache::vhost { 'tse-files':
    vhost_name    => '*',
    port          => '80',
    docroot       => '/opt/tse-files',
    priority      => '10',
    docroot_owner => 'root',
    docroot_group => 'root',
  }


  include profile::master::files::oradb

}
