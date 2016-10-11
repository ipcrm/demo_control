class profile::base::reboots {

  case $::kernel {

    'Windows': {
      package { 'powershell':
        ensure          => latest,
        install_options => ['-pre','--ignore-package-exit-codes'],
        notify          => Reboot['dsc_reboot'],
      }

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

      reboot { 'selinux':
        subscribe => Class['selinux::config'],
        apply     => 'finished',
        timeout   => 0,
      }

    }

    default: {}

  }


}
