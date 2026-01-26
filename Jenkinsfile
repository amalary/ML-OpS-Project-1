pipeline {
  agent any

  environment {
    VENV_DIR    = 'venv'
    GCP_PROJECT = 'machinelearning-ops2025'
    AR_LOCATION = 'us'
    AR_REPO     = 'app-repo'
    IMAGE_NAME  = 'mlops-project'   // MUST be lowercase
    IMAGE_TAG   = 'latest'
  }

  stages {
    stage('Cloning Github repo to Jenkins') {
      steps {
        script {
          echo 'Cloning Github repo to Jenkins............'
          checkout scmGit(
            branches: [[name: '*/main']],
            extensions: [],
            userRemoteConfigs: [[
              credentialsId: 'github-token_1',
              url: 'https://github.com/amalary/ML-OpS-Project-1.git'
            ]]
          )
        }
      }
    }

    stage('Setting up our Virtual Environment and Installing dependencies') {
      steps {
        script {
          echo 'Setting up our Virtual Environment and Installing dependencies............'
          sh """
            set -e
            python -m venv ${VENV_DIR}
            . ${VENV_DIR}/bin/activate
            pip install --upgrade pip
            pip install -e .
          """
        }
      }
    }

    stage('Building and Pushing Docker Image to Artifact Registry') {
      steps {
        withCredentials([file(credentialsId: 'gcp-key', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
          script {
            echo 'Building and Pushing Docker Image to Artifact Registry.................'
            sh """
              set -e

              # Authenticate gcloud with service account
              gcloud auth activate-service-account --key-file="${GOOGLE_APPLICATION_CREDENTIALS}"
              gcloud config set project "${GCP_PROJECT}"

              # Configure Docker credential helper for Artifact Registry
              gcloud auth configure-docker ${AR_LOCATION}-docker.pkg.dev --quiet

              # Build + push to Artifact Registry (all lowercase image name)
              docker build -t ${AR_LOCATION}-docker.pkg.dev/${GCP_PROJECT}/${AR_REPO}/${IMAGE_NAME}:${IMAGE_TAG} .
              docker push ${AR_LOCATION}-docker.pkg.dev/${GCP_PROJECT}/${AR_REPO}/${IMAGE_NAME}:${IMAGE_TAG}
            """
          }
        }
      }
    }
  }
}
