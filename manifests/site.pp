# Disable filebucket by default for all File resources:
File { backup => false }
site {

  flask_app {'prod':
    app_name => 'webui',
    nodes    => {
      Node['rgbank-2.demo.lan'] => [Flask_app::Webhead['prod']],
    },
  }

  flask_app {'dev':
    app_name => 'webui',
    nodes    => {
      Node['rgbank-1.demo.lan'] => [Flask_app::Webhead['dev']],
    },
  }

#  rgbank { 'getting-started':
#    listen_port => 8010,
#    nodes       =>
#    {
#      Node['db2.demo.lan']  => [Rgbank::Db[getting-started]],
#      Node['app2.demo.lan'] => [Rgbank::Web[appserver-01_getting-started]],
#      Node['app3.demo.lan'] => [Rgbank::Web[appserver-02_getting-started]],
#      Node['app4.demo.lan'] => [Rgbank::Web[appserver-03_getting-started]],
#      Node['app5.demo.lan'] => [Rgbank::Web[appserver-04_getting-started]],
#      Node['lb2.demo.lan']  => [Rgbank::Load[getting-started]],
#    },
#  }
#
#  cloudshop { 'split':
#    dbinstance    => 'MYINSTANCE',
#    dbuser        => 'CloudShop',
#    dbpassword    => 'Azure$123',
#    dbname        => 'AdventureWorks2012',
#    nodes         => {
#      Node['example7.demo.lan'] => Cloudshop::App['split'],
#      Node['example8.demo.lan'] => Cloudshop::Db['split'],
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







