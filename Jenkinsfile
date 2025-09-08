pipeline {
    agent any

    environment {
        FLUTTER_HOME = "/opt/flutter"
        PATH = "$FLUTTER_HOME/bin:$PATH"
    }

    stages {

        stage('Checkout SCM') {
            steps {
                echo "Checking out code from GitHub..."
                checkout([$class: 'GitSCM',
                    branches: [[name: 'flutter_cicd_shilpi_branch']],
                    doGenerateSubmoduleConfigurations: false,
                    extensions: [],
                    userRemoteConfigs: [[
                        url: 'git@github.com:Greencreon-LLP-2/GreenBiller-Windows-App-v1.git',
                        credentialsId: 'github-ssh-key'
                    ]]
                ])
            }
        }

        stage('Safe Directory Config') {
            steps {
                sh '''
                # Mark Jenkins workspace and Flutter directory as safe for Git
                git config --global --add safe.directory $WORKSPACE
                git config --global --add safe.directory $FLUTTER_HOME
                '''
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                echo "Getting Flutter dependencies..."
                flutter pub get
                '''
            }
        }

        stage('Build Web') {
            steps {
                sh '''
                echo "Building Flutter Web..."
                flutter build web --release --no-tree-shake-icons
                '''
            }
        }

        stage('Deploy Web') {
            steps {
                echo "Deploy your web build here (example: copy to server or S3)..."
                // sh 'rsync -avz build/web/ user@server:/var/www/html/'
            }
        }
    }

    post {
        success {
            echo "Build and deploy completed successfully!"
        }
        failure {
            echo "Build failed!"
        }
    }
}
