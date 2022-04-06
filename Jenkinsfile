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
          docker.build 'oabuoun/rest_mongo'
        }
      }
    }
  }
}