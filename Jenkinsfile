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
    stages {
        stage("increment version") {
            steps {
                script {
                    echo 'incrementing app version ... '
                    sh 'mvn build-helper:parse-version versions:set \
                    -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.minorVersion}.\\\${parsedVersion.nextIncrementalVersion} \
                    versions:commit'
                    def matcher = readFile('pom.xml') =~ '<version>(.+)</version>'
                    def version = matcher[0][1]
                    env.IMAGE_NAME = "dineshdocker55/aws-java-maven:${version}-${BUILD_NUMBER}"
                }
            }
        }
        stage('build app') {
            steps {
                echo 'building application jar...'
                buildJar()
            }
        }
stage('build image') {
            steps {
                script {
                    echo "building the docker image ${IMAGE_NAME}..."
                    sh "docker build -t ${IMAGE_NAME} ."
                    dockerLogin()
                    dockerPush(env.IMAGE_NAME)
                }
            }
        }
stage("deploy") {
    steps {
        script {
            echo 'deploying docker image to EC2...'
            def shellCmd = "bash ./server-cmds.sh ${IMAGE_NAME}"
            sshagent(['ec2-server-key']) {
                sh "scp -o StrictHostKeyChecking=no server-cmds.sh ec2-user@43.204.148.197:/home/ec2-user"
                sh "scp -o StrictHostKeyChecking=no docker-compose.yaml ec2-user@43.204.148.197:/home/ec2-user"
                sh "ssh -o StrictHostKeyChecking=no ec2-user@43.204.148.197 ${shellCmd}"
            }
        }
    }               
}
        stage("commit version update") {
            steps {
            withCredentials([usernamePassword(credentialsId: 'github-credentials', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
            sh 'git config --global user.email "jenkins@example.com"'
            sh 'git config --global user.name "jenkins"'
            sh 'git status'
            sh 'git branch'
            sh 'git config --list'
                
            sh "git remote set-url origin https://${USER}:${PASS}@github.com/Dinesh-DevOps55/aws-java-maven-app.git"
            sh 'git add .'
            sh 'git commit -m "ci: version bump"'
            sh 'git push origin HEAD:jenkins-jobs'
      }
            }
        }
    }
}
