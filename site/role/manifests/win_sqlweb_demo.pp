class role::win_sqlweb_demo {

  include ::profile::base
  include ::profile::database::sqlserver
  include ::profile::apps::cloudshop

}
