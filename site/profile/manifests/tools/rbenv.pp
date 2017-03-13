class profile::tools::rbenv {

  class {'::rbenv': }
  rbenv::plugin {'rbenv/ruby-build': }
  rbenv::build { '2.3.1': global => true }

}
