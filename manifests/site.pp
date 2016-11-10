# Disable filebucket by default for all File resources:
File { backup => false }

# Applications managed by App Orchestrator are defined in the site block.
site {

#  rgbank { 'getting-started':
#    listen_port => 8010,
#    nodes       =>
#    {
#      Node['db2.demo.lan']  => [Rgbank::Db[getting-started]],
#      Node['app2.demo.lan'] => [Rgbank::Web[appserver-01_getting-started]],
#      Node['app3.demo.lan'] => [Rgbank::Web[appserver-02_getting-started]],
#      Node['lb2.demo.lan']  => [Rgbank::Load[getting-started]],
#    },
#  }

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

}







#      Node['app4.demo.lan'] => [Rgbank::Web[appserver-01_getting-started]],
#      Node['app5.demo.lan'] => [Rgbank::Web[appserver-02_getting-started]],
