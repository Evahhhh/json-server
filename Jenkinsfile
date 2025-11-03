pipeline {
    agent any

    tools {
        nodejs "nodejs"
    }

    environment {
        DOCKER_IMAGE = "ghcr.io/evahhh/json-server"
        VERSION = "build-${env.BUILD_NUMBER}"
    }

    stages {
        stage('Clone') { 
            steps { 
                echo "Clone repo" 
                checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[credentialsId: '95bcb5db-9db0-4e86-95b7-21b76b6bf690', url: 'https://github.com/Evahhhh/json-server']])
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
              echo "Build Docker image"
              sh "docker build -t ${IMAGE}:${VERSION} ."
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: '95bcb5db-9db0-4e86-95b7-21b76b6bf690', usernameVariable: 'GH_USER', passwordVariable: 'GH_TOKEN')]) {
                    sh """
                        echo $GH_TOKEN | docker login ghcr.io -u $GH_USER --password-stdin
                        docker push ${IMAGE}:${VERSION}
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
