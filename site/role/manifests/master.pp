class role::master {

  include ::profile::base
  include ::profile::webserver::apache
  include ::profile::master

}
