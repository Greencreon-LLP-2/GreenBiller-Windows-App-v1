pipeline {
    agent any

    environment {
        ANDROID_HOME = "/home/hp/Android/5dk"
        PATH = "$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"
        FLUTTER_VERSION = "3.35.2"
        FLUTTER_DIR = "$WORKSPACE/flutter/flutter"
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo "Checking out code from GitHub..."
                git branch: 'savio_branch_getx_fix',
                    url: 'https://github.com/Greencreon-LLP-2/GreenBiller-Windows-App-v1.git',
                    credentialsId: 'github-cred'
            }
        }

        stage('Setup Flutter') {
            steps {
                echo "Setting up Flutter SDK..."
                sh '''
                mkdir -p $WORKSPACE/flutter
                cd $WORKSPACE/flutter

                if [ ! -d flutter ]; then
                  wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz
                  tar xf flutter_linux_${FLUTTER_VERSION}-stable.tar.xz
                  rm flutter_linux_${FLUTTER_VERSION}-stable.tar.xz
                fi

                export PATH="$WORKSPACE/flutter/flutter/bin:$PATH"

                flutter --version
                flutter doctor
                '''
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '$FLUTTER_DIR/flutter pub get'
            }
        }

        stage('Run Tests') {
            steps {
                sh '$FLUTTER_DIR/flutter test || true'
            }
        }

        stage('Build APK') {
            steps {
                echo "Building release APK..."
                sh '$FLUTTER_DIR/flutter build apk --release'
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
