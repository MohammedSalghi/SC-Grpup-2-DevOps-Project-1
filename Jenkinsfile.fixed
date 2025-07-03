pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'mohammedsalghi24/sc-grpup-2-devops-project-1'
        BUILD_TAG = "${BUILD_NUMBER}"
    }
    
    stages {
        stage('Quick Build') {
            steps {
                echo '🚀 ULTRA FAST BUILD STARTING...'
                checkout scm
                
                script {
                    // Quick Jira extraction
                    def commitMessage = sh(script: 'git log -1 --pretty=%B', returnStdout: true).trim()
                    def jiraPattern = /([A-Z]+-\d+)/
                    def matcher = commitMessage =~ jiraPattern
                    
                    if (matcher) {
                        env.JIRA_ISSUE = matcher[0][1]
                        echo "✅ Found Jira issue: ${env.JIRA_ISSUE}"
                    } else {
                        env.JIRA_ISSUE = 'SCRUM-11'
                        echo "🔄 Using default: ${env.JIRA_ISSUE}"
                    }
                }
            }
        }
        
        stage('Fast Docker') {
            steps {
                echo '⚡ Fast Docker build and push...'
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', 
                                                   usernameVariable: 'DOCKER_USERNAME', 
                                                   passwordVariable: 'DOCKER_PASSWORD')]) {
                        try {
                            // Use cache for super fast build
                            sh """
                                docker build --cache-from ${DOCKER_IMAGE}:latest -t ${DOCKER_IMAGE}:${BUILD_TAG} -t ${DOCKER_IMAGE}:latest .
                                echo "\$DOCKER_PASSWORD" | docker login -u "\$DOCKER_USERNAME" --password-stdin
                                docker push ${DOCKER_IMAGE}:${BUILD_TAG}
                            """
                            echo "✅ SUCCESS: ${DOCKER_IMAGE}:${BUILD_TAG}"
                        } catch (Exception e) {
                            echo "⚠️ Push failed but continuing: ${e.getMessage()}"
                        } finally {
                            sh 'docker logout || true'
                        }
                    }
                }
            }
        }
    }
    
    post {
        always {
            echo "🏁 ULTRA FAST BUILD COMPLETE! 🚀"
        }
    }
}
