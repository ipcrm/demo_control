properties([gitLabConnection('git.demo.lan')])
puppet.credentials 'pe-access-token'

node {
  dir('control-repo') {
    git url: 'git@git.demo.lan:puppet/control-repo.git', branch: env.BRANCH_NAME

    stage('Lint Control Repo'){
      withEnv(['PATH+EXTRA=/usr/local/bin']) {
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
      withEnv(['PATH+EXTRA=/usr/local/bin']) {
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
      withEnv(['PATH+EXTRA=/usr/local/bin']) {
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

    stage("Promote To Environment"){
      puppet.codeDeploy env.BRANCH_NAME
    }
  }

  if (env.BRANCH_NAME == 'production'){

    stage("Release To DEV"){
      puppet.job 'production', query: 'facts { name = "appenv" and value = "dev"}'
    }

    stage("Release To QA"){
      puppet.job 'production', query: 'facts { name = "appenv" and value = "qa"}'
    }

    input 'Ready to release to production?'
    stage("Release To Production"){
      puppet.job 'production', query: 'facts { name = "appenv" and value = "production"}'
    }

  }

}
