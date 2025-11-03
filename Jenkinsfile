pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "ghcr.io/evahhh/json-server"
    }

    stages {
        stage('Clone') {
            steps {
                git 'https://github.com/Evahhhh/json-server.git'
            }
        }

        stage('Install dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Build') {
            steps {
                sh 'npm run build'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'npm test'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def buildNumber = env.BUILD_NUMBER
                    sh "docker build -t ${DOCKER_IMAGE}:build-${buildNumber} ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([string(credentialsId: 'GITHUB_TOKEN', variable: 'GITHUB_TOKEN')]) {
                    sh """
                    echo $GITHUB_TOKEN | docker login ghcr.io -u evahhh --password-stdin
                    docker push ${DOCKER_IMAGE}:build-${env.BUILD_NUMBER}
                    """
                }
            }
        }

        stage('Tag Git Repo') {
            steps {
                script {
                    sh "git tag -a v${env.BUILD_NUMBER} -m 'Build ${env.BUILD_NUMBER}'"
                    sh "git push origin --tags"
                }
            }
        }
    }

    post {
        success {
            echo "Build and Docker image pushed successfully!"
        }
        failure {
            echo "Build failed!"
        }
    }
}
