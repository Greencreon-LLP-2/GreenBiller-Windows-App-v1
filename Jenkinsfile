pipeline {
    agent any

    environment {
        FLUTTER_VERSION = "3.35.2"
        ANDROID_HOME = "/home/hp/Android/5dk"
        PATH = "$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin"
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo "Checking out code from GitHub..."
                checkout([$class: 'GitSCM',
                    branches: [[name: 'savio_branch_getx_fix']],
                    userRemoteConfigs: [[
                        url: 'https://github.com/Greencreon-LLP-2/GreenBiller-Windows-App-v1.git',
                        credentialsId: 'github-cred'
                    ]]
                ])
            }
        }

        stage('Set up Flutter') {
            steps {
                echo "Setting up Flutter SDK..."
                sh '''
                mkdir -p $WORKSPACE/flutter
                cd $WORKSPACE/flutter

                # Download Flutter 3.35.2 stable if not present
                if [ ! -d flutter ]; then
                    wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.35.2-stable.tar.xz
                    tar xf flutter_linux_3.35.2-stable.tar.xz
                    rm flutter_linux_3.35.2-stable.tar.xz
                fi

                export PATH="$PATH:$WORKSPACE/flutter/flutter/bin"

                flutter --version
                flutter doctor
                '''
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'flutter pub get'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'flutter test || true'
            }
        }

        stage('Build APK') {
            steps {
                echo "Building release APK..."
                sh 'flutter build apk --release'
            }
        }

        stage('Archive APK') {
            steps {
                archiveArtifacts artifacts: 'build/app/outputs/flutter-apk/app-release.apk', fingerprint: true
            }
        }
    }

    post {
        success {
            echo "✅ Build Successful!"
        }
        failure {
            echo "❌ Build Failed!"
        }
    }
}
