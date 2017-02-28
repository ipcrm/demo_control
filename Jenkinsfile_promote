
node {

  dir('util') {
    git 'git@github.com:ipcrm/pfparser.git'
  }

  dir('control-repo') {
    git url: 'git@github.com:ipcrm/demo_control.git', branch: 'production'

    stage('Update Control Repo'){
      withEnv(['PATH=/usr/local/bin:$PATH']) {
        ansiColor('xterm') {
          previous_version = sh(returnStdout: true, script: '''
            source ~/.bash_profile
            rbenv global 2.3.1
            eval "$(rbenv init -)"
            ruby ../util/pfparser.rb -r -f Puppetfile -m $MODULE -p $PARAM -d $TAG
          ''')
        }
      }
      withEnv(['PATH=/usr/local/bin:$PATH']) {
        ansiColor('xterm') {
          sh '''
          git add Puppetfile
          git commit -m "${BUILD_TAG}"
          git push origin $BUILD_BRANCH
          '''
        }
      }
    }

    stage('Promote to Prod'){
      puppet.credentials 'pe-access-token'
      puppet.codeDeploy 'production'
    }

    try {
      stage('Prod: Canary Test'){
        puppet.credentials 'pe-access-token'
        puppet.job 'production', query: 'nodes { facts { name = "canary" and value = true }}'
      }
    } catch (error) {

      stage('Revert Control Repo'){
        env.TAG=previous_version
        withEnv(['PATH=/usr/local/bin:$PATH']) {
          ansiColor('xterm') {
            sh '''
              source ~/.bash_profile
              rbenv global 2.3.1
              eval "$(rbenv init -)"
              ruby ../util/pfparser.rb -r -f Puppetfile -m $MODULE -p $PARAM -d $TAG
            '''
          }
        }
        withEnv(['PATH=/usr/local/bin:$PATH']) {
          ansiColor('xterm') {
            sh '''
            git add Puppetfile
            git commit -m "${BUILD_TAG}"
            git push origin $BUILD_BRANCH
            '''
          }
        }
      }

      stage('Downgrade Production'){
        puppet.credentials 'pe-access-token'
        puppet.codeDeploy 'production'
      }

      stage('Prod: Canary Test'){
        puppet.credentials 'pe-access-token'
        puppet.job 'production', query: 'nodes { facts { name = "canary" and value = true }}'
      }

      currentBuild.result = 'FAILURE'
    }

  }
}
