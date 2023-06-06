pipeline {
  agent {
    docker {
      image 'node:12.22.1'
      args '-u root' // Use root user to install additional packages if needed
    }
  }
  
  environment {
    SONAR_URL = "http://localhost:9000"
    DOCKER_IMAGE = "node-app:${BUILD_NUMBER}"
    SONAR_AUTH_TOKEN = credentials('sonarqube')
  }
  
  stages {
//     stage('Checkout') {
//       steps {
//         git 'https://github.com/thissuman/node_app_cicd.git'
        
//       }
  //  }
    
    stage('Build and Test') {
      steps {
        sh 'npm install'
        sh 'npm run test'
      }
    }
    
    stage('Static Code Analysis') {
      steps {
        withSonarQubeEnv('sonar') {
          sh 'npm install -g sonarqube-scanner'
          sh 'sonar-scanner'
        }
      }
    }
    
    stage('Build and Push Docker Image') {
      steps {
        sh 'docker build -t $DOCKER_IMAGE .'
        sh 'docker push $DOCKER_IMAGE'
      }
    }
  }
}
