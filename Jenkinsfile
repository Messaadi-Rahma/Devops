pipeline {
    agent any  // Run on any available Jenkins agent

    environment {
        // DockerHub credentials
        DOCKERHUB_USER = 'rahmamessadi23'               // <-- Replace with your DockerHub username
        IMAGE_NAME = 'devops'               // <-- Your Docker image name
        IMAGE_TAG = 'latest'                   // <-- Tag for the Docker image

        // Jenkins credentials ID for DockerHub (Username with password)
        DOCKERHUB_CREDENTIALS = 'rahmamessadi23'
    }

    stages {

        // ---------------------------------
        stage('Checkout') {
            steps {
                echo "📥 Cloning repository..."
                git branch: 'main', url: 'https://github.com/Messaadi-Rahma/Devops.git'
            }
        }

        // ---------------------------------
        stage('Build with Maven') {
            steps {
                echo "🛠️ Building Java app (skip tests)..."
                // Build the project and skip tests
                sh 'mvn clean package -DskipTests'
            }
        }

        // ---------------------------------
        stage('Run Tests') {
            steps {
                echo "🧪 Running unit tests..."
                // Run unit tests
                sh 'mvn test'
            }
        }

        // ---------------------------------
        stage('Package Application') {
            steps {
                echo "📦 Packaging application..."
                // Build the final JAR package
                sh 'mvn package'
            }
        }

        // ---------------------------------
        stage('Build Docker Image') {
            steps {
                echo "🐳 Building Docker image..."
                // Build the Docker image using Dockerfile in the repo
                script {
                    sh "docker build -t ${DOCKERHUB_USER}/${IMAGE_NAME}:${IMAGE_TAG} ."
                }
            }
        }

        // ---------------------------------
        stage('Push Docker Image') {
            steps {
                echo "📤 Pushing Docker image to DockerHub..."
                script {
                    // Use credentials stored in Jenkins
                    withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS}", usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                        sh """
                        echo "$PASS" | docker login -u "$USER" --password-stdin
                        docker push ${DOCKERHUB_USER}/${IMAGE_NAME}:${IMAGE_TAG}
                        docker logout
                        """
                    }
                }
            }
        }

    }

    // ---------------------------------
    post {
        success {
            echo "✅ Pipeline completed successfully!"
        }
        failure {
            echo "❌ Pipeline failed! Check logs for errors."
        }
    }
}
