class role::master {

  include ::profile::base
  include ::profile::middleware::apache
  include ::profile::master

}
