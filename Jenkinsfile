pipeline {
    agent any

    environment {
        FLUTTER_HOME = "/opt/flutter"
        PATH = "$FLUTTER_HOME/bin:$PATH"
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Using SSH key credentials configured in Jenkins
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/flutter_cicd_shilpi_branch']],
                    doGenerateSubmoduleConfigurations: false,
                    userRemoteConfigs: [[
                        url: 'git@github.com:Greencreon-LLP-2/GreenBiller-Windows-App-v1.git',
                        credentialsId: 'github-ssh-root'
                    ]]
                ])
            }
        }

        stage('Install Dependencies') {
            steps {
                echo 'Installing Flutter dependencies...'
                sh 'flutter pub get'
            }
        }

        stage('Build Web') {
            steps {
                echo 'Building Flutter Web...'
                sh 'flutter build web --release'
            }
        }

        stage('Deploy Web') {
            steps {
                echo 'Deploying Web App to Nginx...'
                // Clean previous build
                sh 'rm -rf /var/www/html/*'
                // Copy new build
                sh 'cp -r build/web/* /var/www/html/'
                // Restart Nginx
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
