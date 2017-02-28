
node {

  dir('control-repo') {
    git url: 'git@github.com:ipcrm/demo_control.git', branch: env.BRANCH_NAME

    stage('Lint Control Repo'){
      withEnv(['PATH=/usr/local/bin:$PATH']) {
        ansiColor('xterm') {
          previous_version = sh(returnStdout: true, script: '''
            source ~/.bash_profile
            rbenv global 2.3.1
            eval "$(rbenv init -)"
            bundle install
            bundle exec rake lint
          ''')
        }
      }
    }
    stage('Syntax Check Control Repo'){
      withEnv(['PATH=/usr/local/bin:$PATH']) {
        ansiColor('xterm') {
          previous_version = sh(returnStdout: true, script: '''
            source ~/.bash_profile
            rbenv global 2.3.1
            eval "$(rbenv init -)"
            bundle install
            bundle exec rake syntax --verbose
          ''')
        }
      }
    }

    stage('Validate Puppetfile in Control Repo'){
      withEnv(['PATH=/usr/local/bin:$PATH']) {
        ansiColor('xterm') {
          previous_version = sh(returnStdout: true, script: '''
            source ~/.bash_profile
            rbenv global 2.3.1
            eval "$(rbenv init -)"
            bundle install
            bundle exec rake r10k:syntax
          ''')
        }
      }
    }

    stage('Promote to Prod'){
      puppet.credentials 'pe-access-token'
      puppet.codeDeploy env.BRANCH_NAME
    }
  }

}

