class profile::base::ssh (
  Boolean $manage_firewall = true,
){

  if $facts['os']['name'] != 'Windows' {

    if !defined(Class['ssh']){

      class{'::ssh':
        ssh_key_import         => false,
        ssh_key_ensure         => absent,
        sshd_config_print_motd => 'no',
        manage_firewall        => $manage_firewall,
      }

    }

  }

}
