pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/<your-username>/cloud-nginx.git'
            }
        }

        stage('Deploy AWS Page') {
            steps {
                sshagent (credentials: ['aws-key']) {
                    sh '''
                    scp -o StrictHostKeyChecking=no index-aws.html ubuntu@<AWS-PUBLIC-IP>:/tmp/index.html
                    ssh ubuntu@<AWS-PUBLIC-IP> "sudo mv /tmp/index.html /var/www/html/index.html && sudo systemctl restart nginx"
                    '''
                }
            }
        }

        stage('Deploy Azure Page') {
            steps {
                sshagent (credentials: ['azure-key']) {
                    sh '''
                    scp -o StrictHostKeyChecking=no index-azure.html azureuser@<AZURE-PUBLIC-IP>:/tmp/index.html
                    ssh azureuser@<AZURE-PUBLIC-IP> "sudo mv /tmp/index.html /var/www/html/index.html && sudo systemctl restart nginx"
                    '''
                }
            }
        }
    }
}
