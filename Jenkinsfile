pipeline {
  agent any
  tools {
      maven 'maven'
      jdk 'jdk17'
  }
  environment {
    GITHUB_URL = "https://github.com/Java-end-to-end-pipeline/backend.git"
    DOCKERHUB_CREDENTIALS = 'docker_token'
    DOCKER_REPOSITORY = 'fedimersni/java-end-to-end-pipeline'
    MAVEN_SETINGS_CONFIG = 'global-maven'
    JENKINS_API_TOKEN = credentials('JENKINS_API_TOKEN')
    CD_PIPELINE_TOKEN = "gitops-token"
  }
  stages {
    stage('Git checkout') {
      steps {
        git branch: 'develop', credentialsId: 'github_credentials', url: "${env.GITHUB_URL}"
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

    stage("Sonarqube") {
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
        withMaven(globalMavenSettingsConfig: "${env.MAVEN_SETINGS_CONFIG}") {
          sh 'mvn deploy -DskipTests=true'
        }
      }
    }

    stage("Docker Build") {
      steps{
        script {
          def commitHash = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
          env.IMAGE_TAG = commitHash
          withDockerRegistry(credentialsId: "${env.DOCKERHUB_CREDENTIALS}") {
            sh 'docker build -t $DOCKER_REPOSITORY:$IMAGE_TAG -t $DOCKER_REPOSITORY:latest .'
          }
        }
      }
    }
    stage("Docker Push") {
      steps{
        script {
          withDockerRegistry(credentialsId: "${env.DOCKERHUB_CREDENTIALS}") {
            sh 'docker push $DOCKER_REPOSITORY:$IMAGE_TAG'
            sh 'docker push $DOCKER_REPOSITORY:latest'
          }
        }
      }
    }
    stage("Trigger CD Pipeline") {
      steps {
        script {
            sh "curl -v -k --user fedimersni:${JENKINS_API_TOKEN} -X POST -H 'cache-control: no-cache' -H 'content-type: application/x-www-form-urlencoded' --data 'IMAGE_TAG=${IMAGE_TAG}' 'http://jenkins:8080/job/java-CD-pipeline/buildWithParameters?token=${env.CD_PIPELINE_TOKEN}'"
        }
      }
    }
  }
}