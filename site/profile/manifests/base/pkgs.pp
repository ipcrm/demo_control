class profile::base::pkgs {

  case $::kernel {
    'Windows': {

      require ::profile::base::services
      contain ::chocolatey

      Package{
        provider => 'chocolatey',
        require  => [
          Class['chocolatey'],
          Service['wuauserv'],
        ],
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

      package { ['uniextract', 'git', '7zip']:
        ensure   => present,
      }

    }

    'Linux': {

      if $::facts['os']['family'] == 'RedHat' {
        include ::epel


        if $::facts['os']['release']['major'] + 0 >= 7 {

          file {'/etc/yum.repos.d/misc.repo':
            ensure => present,
            mode   => '0644',
            group  => root,
            owner  => root,
            source => 'puppet:///modules/profile/misc.repo',
            notify => Exec['yum clean all'],
          }

          exec {'yum clean all':
            cmd         => 'yum clean all',
            refreshonly => true,
          }

          package {['mcollective-shell-agent','mcollective-shell-client']:
            ensure => present,
          }
        }
      }

      ensure_packages(['wget','unzip','git'])
    }

    default: {}

  }


}
