pipeline {
    agent any
    
    environment {
        SERVICE_NAME = "webapp_konzek"
        ORGANIZATION_NAME = "hasan05"
        DOCKERHUB_USERNAME = "hasan05"
        REPOSITORY_TAG = "${DOCKERHUB_USERNAME}/${ORGANIZATION_NAME}-${SERVICE_NAME}:${BUILD_ID}"
    }
   
    stages {
        stage ('Build and Push Image') {
            steps {
                script {
                    // Docker Hub'a giriş yap
                    withDockerRegistry([credentialsId: 'docker-hub', url: "https://index.docker.io/v1/"]) {
                        // Docker imajını oluştur ve Docker Hub'a yükle
                        sh "docker build -t ${REPOSITORY_TAG} ."
                        sh "docker push ${REPOSITORY_TAG}"
                    }
                }
            }
        }

        stage('Deploy Kubernetes Resources') {
            steps {
                script {
                    sh 'kubectl apply -f namespace.yml -f hpa.yml -f svc.yml -f deploy.yml'
                }
            }
        }
    }
}
