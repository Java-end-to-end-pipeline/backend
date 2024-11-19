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
        git branch: 'main', credentialsId: 'github_credentials', url: "${env.GITHUB_URL}"
      }
    }

    stage("Compile") {
      steps{
        sh "mvn compile"
      }
    }

    stage("Unit Tests") {
      steps{
        sh "mvn test -DskipTests=true"
      }
    }

    stage("Unit Tests") {
      steps{
        withSonarQubeEnv('sonar-scanner') {
          sh "mvn sonar:sonar"
        }
      }
    }

    stage("Build") {
      steps{
        sh 'mvn package -DskipTests=true'
      }
    }

    stage("Push to Nexus") {
      steps{
        withMaven(globalMavenSettingsConfig: 'global-maven') {
          sh 'mvn deploy -DskipTests=true'
        }
      }
    }
  }
}