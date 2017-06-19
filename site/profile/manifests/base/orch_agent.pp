class profile::base::orch_agent (
  $ensure = 'present',
)
{
  $puppet_conf = $::kernel ? {
    'windows' => 'C:/ProgramData/PuppetLabs/puppet/etc/puppet.conf',
    default   => '/etc/puppetlabs/puppet/puppet.conf',
  }

  ini_setting { 'puppet agent use_cached_catalog':
    ensure  => $ensure,
    path    => $puppet_conf,
    section => 'agent',
    setting => 'use_cached_catalog',
    # lint:ignore:quoted_booleans
    value   => 'true',
    # lint:endignore
  }

}
