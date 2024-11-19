pipeline {
  agent any
  tools {
      maven 'maven'
      jdk 'jdk17'
  }
  environment {
    GITHUB_URL = "https://github.com/Java-end-to-end-pipeline/backend.git"
  }
  stages {
    stage('Git checkout') {
      steps {
        git branch: 'main', url: '$GITHUB_URL'
      }
    }
  }
}