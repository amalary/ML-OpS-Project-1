pipeline {
  agent any

  environment {
    VENV_DIR    = 'venv'
    GCP_PROJECT = 'machinelearning-ops2025'
    AR_LOCATION = 'us'
    AR_REPO     = 'app-repo'
    IMAGE_NAME  = 'mlops-project'
    IMAGE_TAG   = 'latest'
    GCR_HOST    = 'gcr.io'
    CLOUD_RUN_REGION = 'us-central1'
    CLOUD_RUN_SERVICE = 'chess-backend'
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
    
    stage('Deploying to Cloud Run') {
      steps {
        withCredentials([file(credentialsId: 'gcp-key', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
          script {
            echo 'Deploying to Cloud Run.................'
            sh """
              set -e

              # Authenticate gcloud with service account
              gcloud auth activate-service-account --key-file="${GOOGLE_APPLICATION_CREDENTIALS}"
              gcloud config set project "${GCP_PROJECT}"

              # Deploy to Cloud Run using Artifact Registry image
              gcloud run deploy ${CLOUD_RUN_SERVICE} \
                --image ${AR_LOCATION}-docker.pkg.dev/${GCP_PROJECT}/${AR_REPO}/${IMAGE_NAME}:${IMAGE_TAG} \
                --region ${CLOUD_RUN_REGION} \
                --platform managed \
                --allow-unauthenticated
            """
          }
        }
      }
    }

    stage('Building and Pushing Docker Image to GCR') {
      steps {
        withCredentials([file(credentialsId: 'gcp-key', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
          script {
            echo 'Building and Pushing Docker Image to GCR.................'
            sh """
              set -e

              # Authenticate gcloud with service account
              gcloud auth activate-service-account --key-file="${GOOGLE_APPLICATION_CREDENTIALS}"
              gcloud config set project "${GCP_PROJECT}"

              # Configure Docker credential helper for GCR
              gcloud auth configure-docker ${GCR_HOST} --quiet

              # Build + push to GCR
              docker build -t ${GCR_HOST}/${GCP_PROJECT}/${IMAGE_NAME}:${IMAGE_TAG} .
              docker push ${GCR_HOST}/${GCP_PROJECT}/${IMAGE_NAME}:${IMAGE_TAG}
            """
          }
        }
      }
    }
  }
}
