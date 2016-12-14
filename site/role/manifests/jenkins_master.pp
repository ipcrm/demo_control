class role::jenkins_master {

  include ::profile::base
  include ::profile::webserver::apache
  include ::profile::apps::jenkins

}
