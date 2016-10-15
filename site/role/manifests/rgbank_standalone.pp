class role::rgbank_standalone {

  include ::profile::base
  include ::profile::database::mysql
  include ::profile::webserver::apache
  include ::profile::apps::wordpress
  include ::profile::apps::rgbank

}
