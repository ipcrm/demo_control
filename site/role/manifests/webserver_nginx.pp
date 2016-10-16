class role::webserver_nginx {

  include ::profile::base
  include ::profile::database::mysql_client
  include ::profile::webserver::nginx

}
