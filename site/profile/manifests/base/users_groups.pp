class profile::base::users_groups {

  if $::kernel != 'windows' {

    hiera_hash('groups').each |$g,$v| {
      group{$g:
        * => $v,
      }
    }

    hiera_hash('users').each |$u,$d| {
      accounts::user {$u:
        * => $d,
      }
    }

  }

}
