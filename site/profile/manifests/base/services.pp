class profile::base::services {
  $services = hiera_hash('services',{})
  $_os = downcase($::facts['os']['name'])
  $_os_major = $::facts['os']['release']['major']
  $_os_string = "${_os}${_os_major}"

  if has_key($services,$_os_string) {
    $services[$_os_string].each |$s,$v| {
      service{$s:
        * => $v,
      }
    }
  }

}
