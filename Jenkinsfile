pipeline {
    agent any

    environment {
        ANDROID_HOME = "/home/hp/Android/5dk"
        FLUTTER_DIR = "/home/hp/savio/flutter SDK/flutter"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'savio_branch_getx_fix',
                    url: 'https://github.com/Greencreon-LLP-2/GreenBiller-Windows-App-v1.git',
                    credentialsId: 'github-cred'
            }
        }

        stage('Setup Flutter') {
            steps {
                sh '''
                # Prepend Flutter and Android SDK to PATH
                export PATH="$FLUTTER_DIR/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"

                flutter --version
                flutter doctor
                '''
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                export PATH="$FLUTTER_DIR/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"
                flutter pub get
                '''
            }
        }

        stage('Run Tests') {
            steps {
                sh '''
                export PATH="$FLUTTER_DIR/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"
                flutter test || true
                '''
            }
        }

        stage('Build APK') {
            steps {
                sh '''
                export PATH="$FLUTTER_DIR/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"
                flutter build apk --release
                '''
            }
        }

        stage('Archive APK') {
            steps {
                archiveArtifacts artifacts: 'build/app/outputs/flutter-apk/app-release.apk', fingerprint: true
            }
        }
    }

    post {
        success { echo "✅ Build Successful!" }
        failure { echo "❌ Build Failed!" }
    }
}
