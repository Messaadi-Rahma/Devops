pipeline {
    agent any

    environment {
        // Adjust JAVA_HOME path if Jenkins node uses a different one
        JAVA_HOME = '/usr/lib/jvm/java-21-openjdk-amd64'
        PATH = "${JAVA_HOME}/bin:${PATH}"
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Cloning repository..."
                git branch: 'main', url: 'https://github.com/Messaadi-Rahma/Devops.git'
            }
        }

        stage('Build') {
            steps {
                echo "Building (skip tests)..."
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Test') {
            steps {
                echo "Running tests..."
                sh 'mvn test'
            }
        }

        stage('Package') {
            steps {
                echo "Packaging application..."
                sh 'mvn package'
            }
        }

        stage('Archive') {
            steps {
                echo "Archiving .jar..."
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }

        // You can add a Deploy stage later if needed
    }

    post {
        success {
            echo "✅ Build succeeded"
        }
        failure {
            echo "❌ Build failed"
        }
    }
}
