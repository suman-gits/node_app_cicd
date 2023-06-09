pipeline {
  agent {
    docker {
      image 'node:lts-alpine3.18'
      args '-u root' 
    }
  }
   tools {
        jdk 'java8' 
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
        
      }
    }

    
    stage('Static Code Analysis') {
      steps {
         sh 'npm install -g sonarqube-scanner'
            sh '''
    sonar-scanner \
      -Dsonar.login=$SONAR_AUTH_TOKEN \
      -Dsonar.host.url=$SONAR_URL \
    '''
        }
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
