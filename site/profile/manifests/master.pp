class profile::master {

  contain ::profile::master::puppetserver
  contain ::profile::master::node_groups
  contain ::profile::master::fileserver
  contain ::profile::master::repos

}
