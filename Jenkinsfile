def handleCheckout = {
  if (env.gitlabMergeRequestId) {
    sh "echo 'Merge request detected. Merging...'"
    def credentialsId = scm.userRemoteConfigs[0].credentialsId
    checkout ([
      $class: 'GitSCM',
      branches: [[name: "${env.gitlabSourceNamespace}/${env.gitlabSourceBranch}"]],
      extensions: [
        [$class: 'PruneStaleBranch'],
        [$class: 'CleanCheckout'],
        [
          $class: 'PreBuildMerge',
          options: [
            fastForwardMode: 'NO_FF',
            mergeRemote: env.gitlabTargetNamespace,
            mergeTarget: env.gitlabTargetBranch
          ]
        ]
      ],
      userRemoteConfigs: [
        [
          credentialsId: credentialsId,
          name: env.gitlabTargetNamespace,
          url: env.gitlabTargetRepoSshURL
        ],
        [
          credentialsId: credentialsId,
          name: env.gitlabSourceNamespace,
          url: env.gitlabTargetRepoSshURL
        ]
      ]
    ])
  } else {
    sh "echo 'No merge request detected. Checking out current branch'"
    checkout ([
      $class: 'GitSCM',
      branches: scm.branches,
      extensions: [
          [$class: 'PruneStaleBranch'],
          [$class: 'CleanCheckout']
      ],
      userRemoteConfigs: scm.userRemoteConfigs
    ])
  }
}

node {

  stage('setup') {
    handleCheckout()
  }

  parallel (
    phase1: {
      stage('Lint Control Repo'){
        withEnv(['PATH=/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin']) {
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
    },
    phase2: {
      stage('Syntax Check Control Repo'){
        withEnv(['PATH=/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin']) {
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
    },
    phase3: {
      stage('Validate Puppetfile in Control Repo'){
        withEnv(['PATH=/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin']) {
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
    }
  )

}

if (! env.gitlabMergeRequestId) {
  stage("Promote To Environment"){
    puppet.credentials 'pe-access-token'
    puppet.codeDeploy env.gitlabBranch
  }
}

