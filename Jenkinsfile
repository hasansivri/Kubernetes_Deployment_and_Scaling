pipeline {
    agent any
    
    environment {
        SERVICE_NAME = "webapp_konzek"
        ORGANIZATION_NAME = "hasan05"
        DOCKERHUB_USERNAME = "hasan05"
        REPOSITORY_TAG = "${DOCKERHUB_USERNAME}/${ORGANIZATION_NAME}-${SERVICE_NAME}:${BUILD_ID}"
        KUBE_MASTER_IP = "54.205.123.79"
        ANS_KEYPAIR = "secondkey" 
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
        
        stage("Install kubectl") {
            steps {
                script {
                    // kubectl'yi indir ve kur
                    sh """
                        curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
                        chmod +x ./kubectl
                        ./kubectl version --client
                    """
                }
            }
        }
        
        stage('Create Infrastructure') {
            steps {
                echo 'Creating kubernetes using Terraform'
                dir('kubernetes') {
                    sh """
                        sed -i 's/secondkey/${ANS_KEYPAIR}/g' main.tf
                        terraform init
                        terraform apply -auto-approve -no-color
                        terraform destroy -auto-approve -no-color
                    """
                }
            }
        }
        
     
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    echo 'Kubernetes\'e dağıtılıyor'
                    // kubectl ile Kubernetes'e dağıt
                    sh 'kubectl apply -f /var/lib/jenkins/workspace/my-first-job/kubernetes/namespace.yml -f /var/lib/jenkins/workspace/my-first-job/kubernetes/hpa.yml -f /var/lib/jenkins/workspace/my-first-job/kubernetes/svc.yml -f /var/lib/jenkins/workspace/my-first-job/kubernetes/deploy.yml --namespace my-namespace'
                }
            }
        }
    }
}
