class profile::base::security::selinux (
  $selinux_mode = 'disabled',
){

  if $::facts['os']['family'] == 'RedHat' {
    class { '::selinux':
      mode   => $selinux_mode,
      notify => Reboot['selinux'],
    }

    reboot { 'selinux':
      subscribe => Class['selinux::config'],
      apply     => 'finished',
      timeout   => 0,
    }

  }

}
