class profile::base::security {

  contain ::profile::base::security::firewall
  contain ::profile::base::security::selinux
  contain ::profile::base::security::ie_esc

}
