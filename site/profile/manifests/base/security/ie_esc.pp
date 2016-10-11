class profile::base::security::ie_esc (
  $ie_esc_enabled = false,
){

  if $::kernel == 'Windows' and $ie_esc_enabled == false {

    registry_value { '32:HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Active Setup\\Installed Components\\IsInstalled':
      type => 'dword',
      data => '00000000',
    }

    registry_key {
      '32:HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Active Setup\\Installed Components\\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}':
      ensure => present,
    }

    registry_value {
      '32:HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Active Setup\\Installed Components\\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}\\IsInstalled':
      type   => 'dword',
      data   => '00000000',
      notify => Exec['gpupdate'],
    }

    registry_key {
      '32:HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Active Setup\\Installed Components\\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}':
      ensure => present,
    }

    registry_value {
      '32:HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Active Setup\\Installed Components\\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}\\IsInstalled':
      type   => 'dword',
      data   => '00000000',
      notify => Exec['gpupdate'],
    }

    exec {'gpupdate':
      command     => 'gpupdate /force',
      refreshonly => true,
      path        => $::path,
    }

  }

}

