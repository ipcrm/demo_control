class profile::base::sudo {

  include ::sudo

  sudo::conf { 'admins':
    priority => 10,
    content  => '%admins ALL=(ALL) NOPASSWD: ALL',
  }

}
