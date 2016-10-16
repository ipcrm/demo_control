class profile::database::mysql_client {
  class { 'mysql::client': }
  class { 'mysql::bindings::php': }
}
