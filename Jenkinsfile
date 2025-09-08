pipeline {
    agent any

    environment {
        FLUTTER_HOME = "/opt/flutter"
        PATH = "$FLUTTER_HOME/bin:$PATH"
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Checkout using SSH and Jenkins credential
                git branch: 'flutter_cicd_shilpi_branch',
                    url: 'git@github.com:Greencreon-LLP-2/GreenBiller-Windows-App-v1.git',
                    credentialsId: 'github-ssh-key'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                # Add current workspace as safe directory
                git config --global --add safe.directory $WORKSPACE
                # Add flutter installation directory as safe directory
                git config --global --add safe.directory $FLUTTER_HOME
                # Install dependencies
                flutter pub get
                '''
            }
        }

        stage('Build Web') {
            steps {
                sh 'flutter build web'
            }
        }

        stage('Deploy Web') {
            steps {
                sh '''
                # Clean previous build
                rm -rf /var/www/html/*
                # Copy new build to Nginx directory
                cp -r build/web/* /var/www/html/
                # Restart Nginx
                systemctl restart nginx
                '''
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
