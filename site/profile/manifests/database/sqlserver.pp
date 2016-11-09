class profile::database::sqlserver {

  class {'::tse_sqlserver':
    admin_user => 'Administrator'
  }

}
