pipeline {
  agent any
  options {
    timestamps()
  }
  environment {
    ANSIBLE_STDOUT_CALLBACK = 'yaml'
  }
  triggers {
    // If webhooks aren't set up, this will check for changes periodically.
    pollSCM('H/5 * * * *')
  }
  stages {
    stage('Checkout') {
      steps {
        git url: 'https://github.com/Sindhura-krl/Cloud_nginx.git', branch: 'main'
      }
    }
    stage('Sanity checks') {
      steps {
        ansiColor('xterm') {
          sh '''
            ansible --version
            ansible-playbook -i inventories/inventory.yaml playbooks/jenkins_deploy.yaml --syntax-check
            ansible-inventory -i inventories/inventory.yaml --list >/dev/null
          '''
        }
      }
    }
    stage('Deploy to AWS & Azure') {
      steps {
        sshagent(credentials: ['jenkins-ssh']) {
          ansiColor('xterm') {
            sh '''
              ansible-playbook -i inventories/inventory.yaml playbooks/jenkins_deploy.yaml -vv
            '''
          }
        }
      }
    }
    stage('Verify externally') {
      steps {
        ansiColor('xterm') {
          sh '''
            AWS_IP=$(awk '/^aws-app/ { for(i=1;i<=NF;i++) if($i ~ /ansible_host=/){split($i,a,"="); print a[2]}}' inventories/inventory.yaml)
            AZURE_IP=$(awk '/^azure-app/ { for(i=1;i<=NF;i++) if($i ~ /ansible_host=/){split($i,a,"="); print a[2]}}' inventories/inventory.yaml)
            curl -s --max-time 5 "http://$AWS_IP/"   | grep -q "Welcome to AWS"
            curl -s --max-time 5 "http://$AZURE_IP/" | grep -q "Welcome to Azure"
          '''
        }
      }
    }
  }
  post {
    success { echo '✅ Deployed and verified.' }
    failure { echo '❌ Deployment failed. Check console log.' }
  }
}
