class role::webserver_apache {

  include ::profile::base
  include ::profile::database::mysql_client
  include ::profile::webserver::apache

}
