#!/usr/bin/env groovy

library identifier: 'jenkins-shared-library@master', retriever: modernSCM(
    [$class: 'GitSCMSource',
    remote: 'https://github.com/Dinesh-DevOps55/jenkins-shared-library',
    credentialsID: 'github-credentials'
    ]
)

pipeline {
    agent any
    tools {
         maven 'maven-3.9'
    }
    environment {
        IMAGE_NAME = 'dineshdocker55/java-maven:1.0'
    }
    stages {
        stage('build app') {
            steps {
                echo 'building application jar...'
                buildJar()
            }
        }
        stage('build image') {
            steps {
                script {
                    echo 'building the docker image...'
                    buildImage(env.IMAGE_NAME)
                    dockerLogin()
                    dockerPush(env.IMAGE_NAME)
                }
            }
        } 
        stage("deploy") {
            steps {
                script {
                    echo 'deploying docker image to EC2...'
                    def dockerComposeCmd = "docker-compose -f docker-compose.yaml up -- detach"
                    sshagent(['ec2-server-key']) {
                    sh "scp docker-compose.yaml ec2-user@13.233.158.9:/home/ec2-user"
                    sh "ssh -o StrictHostKeyChecking=no ec2-user@13.233.158.9 ${dockerComposeCmd}"
                    }
                }
            }               
        }
    }
}
