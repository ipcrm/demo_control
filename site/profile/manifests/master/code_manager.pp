class profile::master::code_manager(
  $certname = $::fqdn,
) {

  require ::puppet_enterprise::profile::master

  $replication_mode = $::puppet_enterprise::profile::master::replication_mode
  $r10k_remote = $::puppet_enterprise::profile::master::r10k_remote
  $r10k_proxy = $::puppet_enterprise::profile::master::r10k_proxy
  $r10k_private_key = $::puppet_enterprise::profile::master::r10k_private_key
  $file_sync_decision = $::puppet_enterprise::profile::master::file_sync_decision
  $ssl_listen_port = $::puppet_enterprise::profile::master::ssl_listen_port

  if (!pe_compile_master() and $replication_mode != 'replica') {
      class {'::puppet_enterprise::master::code_manager':
        certname              => $certname,
        remote                => $r10k_remote,
        proxy                 => $r10k_proxy,
        private_key           => $r10k_private_key,
        file_sync_auto_commit => $file_sync_decision,
        puppet_master_port    => $ssl_listen_port,
        require               => Package['pe-puppetserver'],
      }
  }

}
