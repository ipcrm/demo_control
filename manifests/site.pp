## site.pp ##

# Disable filebucket by default for all File resources:
File { backup => false }

# Applications managed by App Orchestrator are defined in the site block.
#site {
#  rgbank { 'getting-started':
#    listen_port => 8010,
#    nodes       => {
#        Node['appserver1d.pdx.puppetlabs.demo'] => [Rgbank::Db[getting-started]],
#        Node['appserver1b.pdx.puppetlabs.demo'] => [Rgbank::Web[appserver-01_getting-started]],
#        Node['appserver1c.pdx.puppetlabs.demo'] => [Rgbank::Web[appserver-02_getting-started]],
#        Node['appserver1a.pdx.puppetlabs.demo'] => [Rgbank::Load[getting-started]],
#    },
#  }
#}
