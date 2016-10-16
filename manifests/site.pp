## site.pp ##

# Disable filebucket by default for all File resources:
File { backup => false }

# Applications managed by App Orchestrator are defined in the site block.
site {
  rgbank { 'getting-started':
    listen_port => 8010,
    nodes       =>
    {
      Node['db1.demo.lan']  =>[Rgbank::Db[getting-started]],
      Node['app1.demo.lan'] => [Rgbank::Web[appserver-01_getting-started]],
      #Node['appserver1c.pdx.puppetlabs.demo'] => [Rgbank::Web[appserver-02_getting-started]],
      Node['lb1.demo.lan']  => [Rgbank::Load[getting-started]],
    },
  }
}
