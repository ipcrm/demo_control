node {

  stage('setup') {
    withEnv(['PATH=/usr/local/bin:$PATH']) {
      ansiColor('xterm') {
        gitbranch = sh(returnStdout: true, script: '''
          git rev-parse --abbrev-ref HEAD
        ''')
      }
    }
  }

  stage('test'){
    stage('Lint Control Repo'){
      withEnv(['PATH=/usr/local/bin:$PATH']) {
        ansiColor('xterm') {
          sh(script: '''
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
          sh(script: '''
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
          sh(script: '''
            source ~/.bash_profile
            rbenv global 2.3.1
            eval "$(rbenv init -)"
            bundle install
            bundle exec rake r10k:syntax
          ''')
        }
      }
    }
  }

}

stage("Promote To Environment"){
  puppet.credentials 'pe-access-token'
  puppet.codeDeploy gitbranch
}

