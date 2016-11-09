class role::generalserver {

  include ::profile::base
  include ::profile::database::sqlserver
  include ::profile::apps::cloudshop

}
