pipeline {
  agent any
  
  stages {
    stage('Cloning the project from GitHub'){
      steps {
        git branch: 'main',
        url: 'https://github.com/oabu-sg/rest_mongo.git'
      }
    }
    
    stage('Build Docker Image') {
      steps {
        script {
          DOCKER_IMAGE = docker.build 'oabuoun/rest_mongo'
        }
      }
    }
    
    stage('Push to Docker Hub'){
      steps {
        script {
          docker.withRegistry('', 'docker_hub_cred'){
            DOCKER_IMAGE.push()
          }
        }
      }
    }
  }
}