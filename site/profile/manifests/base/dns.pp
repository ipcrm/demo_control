class profile::base::dns (
  Variant[Undef,String] $domain    = undef,
  Array                 $nameserver = ['8.8.8.8','8.8.8.4'],
  Array                 $options    = [],
  Array                 $search     = [],
){

  case $facts['os']['name'] {
    'Windows': {
      $nameserver.each |$n| {
        dsc_xdnsserveraddress{"dnsserver-${n}":
          ensure             => 'present',
          dsc_address        => $n,
          dsc_addressfamily  => 'IPv4',
          dsc_interfacealias => 'Ethernet',
        }
      }
    }

    default: {

      class {'::dnsclient':
        domain      => $domain,
        nameservers => $nameserver,
        options     => $options,
        search      => $search,
      }

    }
  }

}
