class profile::base::security::selinux (
  $selinux_mode = 'disabled',
){

  if $::facts['os']['family'] == 'RedHat' {
    class { '::selinux':
      mode   => $selinux_mode,
      notify => Reboot['selinux'],
    }
  }

}
