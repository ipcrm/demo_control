# Example cross platform generic website class
class profile::example::generic_website {
  if $::kernel == 'Windows' {

      $doc_root = 'C:\inetpub\wwwroot\generic_website'

      $iis_features = [
        'Web-Server',
        'Web-WebServer',
        'Web-Http-Redirect',
        'Web-Mgmt-Console',
        'Web-Mgmt-Tools',
      ]

      windowsfeature { $iis_features:
        ensure => present,
      }

      iis::manage_site {'Default Web Site':
        ensure => absent,
      }

      iis::manage_app_pool {'generic_website':
        require => [
          Windowsfeature[$iis_features],
          Iis::Manage_site['Default Web Site'],
          ],
      }

      iis::manage_site { $::fqdn:
        site_path  => $doc_root,
        port       => '80',
        ip_address => '*',
        app_pool   => 'generic_website',
        require    => [
          Windowsfeature[$iis_features],
          Iis::Manage_app_pool['generic_website']
          ],
      }

      iis::manage_binding {"${::fqdn}-port-8080":
        site_name => $::fqdn,
        protocol  => 'http',
        port      => '8080',
      }

      windows_firewall::exception { 'HTTPTRAFFIC-8080':
        ensure       => present,
        direction    => 'in',
        action       => 'Allow',
        enabled      => 'yes',
        protocol     => 'TCP',
        local_port   => '8080',
        display_name => 'HTTP Inbound 8080',
        description  => 'Inbound rule for HTTP Server - Port 8080',
      }

      windows_firewall::exception { 'HTTPTRAFFIC':
        ensure       => present,
        direction    => 'in',
        action       => 'Allow',
        enabled      => 'yes',
        protocol     => 'TCP',
        local_port   => '80',
        display_name => 'HTTP Inbound',
        description  => 'Inbound rule for HTTP Server - Port 80',
      }

      staging::deploy { 'pl_generic_site.zip':
        source  => 'puppet:///modules/profile/pl_generic_site.zip',
        target  => $doc_root,
        require => Iis::Manage_site[$::fqdn],
        creates => "${doc_root}/index.html",
      }

  } elsif $::kernel == 'Linux' {

    if !defined(Package['unzip']) {
      package {'unzip': ensure => present, }
    }

    $doc_root = '/var/www/generic_website'
    class { '::apache':
        default_vhost => false,
    }

    file { $doc_root:
      ensure => directory,
      owner  => $::apache::user,
      group  => $::apache::group,
      mode   => '0755',
    }

    apache::vhost { $::fqdn:
      port    => '80',
      docroot => $doc_root,
      require => File[$doc_root],
    }

    firewall { '80 allow apache access':
      dport  => [80],
      proto  => tcp,
      action => accept,
    }

    staging::deploy { 'pl_generic_site.zip':
      source  => 'puppet:///modules/profile/pl_generic_site.zip',
      target  => $doc_root,
      require => Apache::Vhost[$::fqdn],
      creates => "${doc_root}/index.html",
    }

  }



}
