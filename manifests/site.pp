# Disable filebucket by default for all File resources:
File { backup => false }
site {

  flask_app {'prod':
    app_name => 'webui',
    nodes    => {
      Node['flask-2.demo.lan'] => [Flask_app::Webhead['prod']],
    },
  }

  flask_app {'dev':
    app_name => 'webui',
    nodes    => {
      Node['flask-1.demo.lan'] => [Flask_app::Webhead['dev']],
    },
  }

#  cloudshop { 'solo':
#    dbinstance                                  => 'MYINSTANCE',
#    dbuser                                      => 'CloudShop',
#    dbpassword                                  => 'Azure$123',
#    dbname                                      => 'AdventureWorks2012',
#    nodes                                       => {
#      Node['cloudshop-solo.demo.lan'] => [Cloudshop::App['solo'], Cloudshop::Db['solo']],
#    },
#  }

#  cloudshop { 'split':
#    dbinstance    => 'MYINSTANCE',
#    dbuser        => 'CloudShop',
#    dbpassword    => 'Azure$123',
#    dbname        => 'AdventureWorks2012',
#    nodes         => {
#      Node['cloudshop-iis.demo.lan'] => Cloudshop::App['split'],
#      Node['cloudshop-db.demo.lan'] => Cloudshop::Db['split'],
#    },
#  }


  $environment = get_compiler_environment()

  # Dynamic application declarations
  # from JSON
  $envs = loadyaml("/etc/puppetlabs/code/environments/${environment}/applications.yaml")
  $applications = pick_default($envs[$environment], {})

  $applications.each |String $type, $instances| {
    $instances.each |String $title, $params| {
      $parsed_parameters = $params.make_application_parameters($title)

      # Because Puppet code expects typed parameters, not just strings representing
      # types, an appropriately transformed version of the $params variable will be
      # used. The resolve_resources() method comes from the tse/to_resource module.
      Resource[$type] { $title:
        * => $parsed_parameters.resolve_resources,
      }
    }
  }
}

if pick($::noop_disable,false) == false {
  if $::role != 'master' {
    notify{'Noop Enabled': }
    noop()
  }
}

#Class <||> ->
  if defined(Class['Profile::Base::Security::Firewall']){
    notify{'test': }
  }






