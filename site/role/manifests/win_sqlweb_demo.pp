class role::win_sqlweb_demo {

  include ::profile::base
  include ::profile::database::sqlserver
  include ::profile::webserver::iis
  include ::profile::apps::cloudshop

}
