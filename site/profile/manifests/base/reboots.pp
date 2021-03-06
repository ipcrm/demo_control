class profile::base::reboots {

  case $::kernel {

    'Windows': {

      reboot {'dsc_install':
        subscribe => Package['powershell'],
        apply     => 'immediately',
        timeout   => 0,
      }

      reboot{'dsc_reboot':
        when    => pending,
        timeout => 15,
      }

    }

    'Linux': {

      if $::facts['os']['family'] == 'RedHat' and $::virtual != 'docker' {

        reboot { 'selinux':
          subscribe => Class['selinux::config'],
          apply     => 'finished',
          timeout   => 0,
        }

      }

    }

    default: {}

  }


}
