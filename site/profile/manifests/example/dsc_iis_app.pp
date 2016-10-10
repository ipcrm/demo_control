class profile::example::dsc_iis_app {
  $doc_root = 'C:\\wwwroot'

  dsc_windowsfeature{'iis':
    dsc_ensure => 'Present',
    dsc_name   => 'Web-Server',
  } ->

  dsc_windowsfeature{'iisscriptingtools':
    dsc_ensure => 'Present',
    dsc_name   => 'Web-Scripting-Tools',
  } ->

  dsc_windowsfeature{'iishttpredirect':
    dsc_ensure => 'Present',
    dsc_name   => 'Web-Http-Redirect',
  } ->

  dsc_windowsfeature{'iismgmtconsole':
    dsc_ensure => 'Present',
    dsc_name   => 'Web-Mgmt-Console',
  } ->

  dsc_windowsfeature{'iismgmttools':
    dsc_ensure => 'Present',
    dsc_name   => 'Web-Mgmt-Tools',
  } ->

  dsc_xwebsite{'default web site':
    dsc_ensure       => 'Present',
    dsc_name         => 'Default Web Site',
    dsc_physicalpath => 'C:\\inetpub\\wwwroot',
    dsc_state        => 'Stopped',
    dsc_bindinginfo  => [{
      protocol => 'HTTP',
      port     => 8080,
    }],
  } ->

  dsc_file { "${doc_root}\\generic_website":
    dsc_ensure          => 'Present',
    dsc_type            => 'Directory',
    dsc_destinationpath => "${doc_root}\\generic_website",
  } ->

  dsc_xwebapppool{'generic_website_apppool':
    dsc_name   => 'generic_website',
    dsc_ensure => 'Present',
    dsc_state  => 'Started',
  } ->

  dsc_xwebsite{'generic_website':
    dsc_ensure          => 'Present',
    dsc_name            => 'generic_website',
    dsc_state           => 'Started',
    dsc_physicalpath    => "${doc_root}\\generic_website",
    dsc_applicationpool => 'generic_website',
    dsc_bindinginfo     => [{
      protocol => 'HTTP',
      port     => 80,
    }],
  } ->

  windows_firewall::exception { 'HTTP':
    ensure       => present,
    direction    => 'in',
    action       => 'Allow',
    enabled      => 'yes',
    protocol     => 'TCP',
    local_port   => '80',
    display_name => 'HTTP Inbound',
    description  => 'Inbound rule for HTTP Server - Port 80',
  } ->

  staging::deploy { 'pl_generic_site.zip':
    source  => 'puppet:///modules/profile/pl_generic_site.zip',
    target  => "${doc_root}\\generic_website",
    creates => "${doc_root}\\generic_website\\index.html",
  }

}


