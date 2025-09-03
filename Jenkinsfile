pipeline {
    agent any

    environment {
        ANDROID_HOME = "/home/hp/Android/5dk"
        PATH+EXTRA = "$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin"
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
                export PATH="$FLUTTER_DIR/bin:$PATH"
                flutter --version
                flutter doctor
                '''
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '$FLUTTER_DIR/bin/flutter pub get'
            }
        }

        stage('Run Tests') {
            steps {
                sh '$FLUTTER_DIR/bin/flutter test || true'
            }
        }

        stage('Build APK') {
            steps {
                sh '$FLUTTER_DIR/bin/flutter build apk --release'
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
