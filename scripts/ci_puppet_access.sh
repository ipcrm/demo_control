#!/bin/bash

/opt/puppetlabs/bin/puppet-access login --username deploy <<EOF
$ORCH_PASSWD
EOF
