pipeline {
  agent {
    docker {
      image 'abhishekf5/maven-abhishek-docker-agent:v1'
      args '--user root -v /var/run/docker.sock:/var/run/docker.sock' // mount Docker socket to access the host's Docker daemon
    }
  }
//   stages {
//     stage('Checkout') {
//       steps {
//         sh 'echo passed'
//         //git branch: 'main', url: 'https://github.com/thissuman/node_app_cicd.git'
//       }
//     }
    stage('Build and Test') {
      steps {
        sh 'mvn clean package'
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
    stage('Update Deployment File') {
        environment {
            GIT_REPO_NAME = "node_app_cicd"
            GIT_USER_NAME = "thissuman"
        }
        steps {
            withCredentials([string(credentialsId: 'github', variable: 'GITHUB_TOKEN')]) {
                sh '''
                    git config user.email "suman.xyz@gmail.com"
                    git config user.name "thissuman"
                    BUILD_NUMBER=${BUILD_NUMBER}
                    sed -i "s/replaceImageTag/${BUILD_NUMBER}/g" deployment-service.yaml
                    git add java-maven-sonar-argocd-helm-k8s/spring-boot-app-manifests/deployment.yml
                    git commit -m "Update deployment image to version ${BUILD_NUMBER}"
                    git push https://${GITHUB_TOKEN}@github.com/${GIT_USER_NAME}/${GIT_REPO_NAME} HEAD:main
                '''
            }
        }
    }
  
}