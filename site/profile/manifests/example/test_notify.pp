class profile::example::test_notify {

  notify{'Test Message':
    message => hiera('testvalue'),
  }

}
