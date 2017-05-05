define util::registry_acl (
  Hash    $ace_hash,
  String  $regkey = $title,
  Boolean $purge = false,
  Boolean $inherit_from_parent = true,
){

  $ace_hash.each |$k,$r| {
    assert_type(String, $r['secprincipal'])
    assert_type(String, $r['inheritance'])
    assert_type(String, $r['propagation'])
    assert_type(String, $r['objaccess'])
    assert_type(String, $r['objtype'])
    assert_type(Boolean, $r['remove_ace'])

    if ($r['purge'] == true) and ($r['remove_ace'] == true) {
      raise('You cannot set both purge and remove_ace to true!')
    }
  }

  exec {"updating acl for: ${title}":
    unless   => template('util/check_acl.ps1.erb'),
    command  => template('util/set_acl.ps1.erb'),
    provider => powershell,
  }

}
