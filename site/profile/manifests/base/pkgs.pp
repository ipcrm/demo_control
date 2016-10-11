class profile::base::pkgs {

  case $::kernel {
    'Windows': {

      require ::profile::base::services
      contain chocolatey

      Package{
        provider => 'chocolatey',
        require  => [
          Class['chocolatey'],
          Service['wuauserv'],
        ]
      }

      package { 'powershell':
        ensure          => latest,
        install_options => ['-pre','--ignore-package-exit-codes'],
      }

      $dotnetver = hiera('dotnet_ver', '4.6.2')
      package { "dotnet-${dotnetver}":
        ensure => present,
        notify => Reboot['dsc_reboot'],
      }

      package { ['uniextract', 'git']:
        ensure   => present,
      }

    }

    'Linux': {

      if $::facts['os']['family'] == 'RedHat' {
        include ::epel
      }

      ensure_packages(['wget','unzip','git'])
    }

    default: {}

  }


}
