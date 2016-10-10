class profile::base::reboots {

  if $::kernel == 'Windows' {

    reboot{'dsc_reboot':
      when    => pending,
      timeout => 15,
    }

  }

}
