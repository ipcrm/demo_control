class profile::base::sudo {

  class {'::sudo': }

  sudo::conf { 'admins':
    priority => 10,
    content  => '%admins ALL=(ALL) NOPASSWD: ALL',
  }

  sudo::conf { 'centos':
    priority => 10,
    content  => 'centos ALL=(ALL) NOPASSWD:ALL',
  }

}
