pipeline {
  agent {
    docker { image 'node:12.2.0-alpine' }}
     environment {
        HOME = '.'
    
   
  }
    stages {
//     stage('Checkout') {
//       steps {
//         sh 'echo passed'
//         //git branch: 'main', url: 'https://github.com/thissuman/node_app_cicd.git'
//       }
//     }
    stage('Build and Test') {
      steps {
        sh 'npm install'
      }
    }
    stage('Static Code Analysis') {
      environment {
        SONAR_URL = "http://localhost:9000"
      }
      steps {
        withCredentials([string(credentialsId: 'sonarqube', variable: 'SONAR_AUTH_TOKEN')]) {
          sh 'mvn sonar:sonar -Dsonar.login=$SONAR_AUTH_TOKEN -Dsonar.host.url=${SONAR_URL}' //executes sonar code analysis
        }
      }
    }
    stage('Build and Push Docker Image') {
      environment {
        DOCKER_IMAGE = "sumannn/nodeapp-cicd:${BUILD_NUMBER}"
        REGISTRY_CREDENTIALS = credentials('docker-cred')
      }
      steps {
        script {
            sh 'docker build -t ${DOCKER_IMAGE} .'
            def dockerImage = docker.image("${DOCKER_IMAGE}")
            docker.withRegistry('https://index.docker.io/v1/', "docker-cred") {
                dockerImage.push()
            }
        }
      }
    }
  }
}
