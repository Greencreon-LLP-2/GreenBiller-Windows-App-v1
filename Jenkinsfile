pipeline {
    agent any

    environment {
        FLUTTER_HOME = "/opt/flutter"
        PATH = "$FLUTTER_HOME/bin:$PATH"
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout([$class: 'GitSCM', 
                    branches: [[name: '*/flutter_cicd_shilpi_branch']], 
                    userRemoteConfigs: [[url: 'git@github.com:Greencreon-LLP-2/GreenBiller-Windows-App-v1.git']]
                ])
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'flutter pub get'
            }
        }

        stage('Build Web') {
            steps {
                sh 'flutter build web'
            }
        }

        stage('Deploy Web') {
            steps {
                // Copy built web files to Nginx
                sh 'rm -rf /var/www/html/*'
                sh 'cp -r build/web/* /var/www/html/'
                sh 'systemctl restart nginx'
            }
        }
    }

    post {
        success {
            echo 'Build & Deployment successful!'
        }
        failure {
            echo 'Build failed!'
        }
    }
}
