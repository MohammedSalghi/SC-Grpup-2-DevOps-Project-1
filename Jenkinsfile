pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'mohammedsalghi24/sc-grpup-2-devops-project-1'
        DOCKER_TAG = "${BUILD_NUMBER}"
        DOCKER_FULL_IMAGE = "${DOCKER_IMAGE}:${DOCKER_TAG}"
        JIRA_ISSUE = 'SCRUM-11'  // Default Jira issue key
    }

    options {
        skipDefaultCheckout(true)
        timestamps()
    }

    stages {
        stage('Clean Workspace') {
            steps {
                echo '🧹 Cleaning workspace...'
                deleteDir()
            }
        }
        stage('Checkout') {
            steps {
                echo '🔄 Checking out code from GitHub...'
                checkout scm
            }
        }
        stage('Extract Jira Issue Key') {
            steps {
                script {
                    def commitMessage = sh(script: "git log -1 --pretty=%B", returnStdout: true).trim()
                    echo "🔍 Commit message: ${commitMessage}"
                    def issueKeyMatch = commitMessage =~ /([A-Z]+-\d+)/
                    if (issueKeyMatch) {
                        env.JIRA_ISSUE = issueKeyMatch[0]
                        echo "✅ Detected Jira Issue Key: ${env.JIRA_ISSUE}"
                    } else {
                        echo "⚠️ No Jira issue key found. Using default: ${env.JIRA_ISSUE}"
                    }
                }
            }
        }
        stage('Build') {
            steps {
                echo '🏗️ Building the application (placeholder for PHP build steps)...'
            }
        }
        stage('Performance Test') {
            steps {
                script {
                    echo '🚀 Running JMeter performance tests...'
                    sh '''
                        mkdir -p jmeter-reports/html
                        if [ -f "performance-test.jmx" ]; then
                            jmeter -n -t performance-test.jmx -l jmeter-reports/results.jtl -e -o jmeter-reports/html
                        else
                            echo "⚠️ No JMeter test file found, skipping performance tests"
                        fi
                    '''
                }
            }
        }
        stage('Archive Artifacts & Publish Report') {
            steps {
                echo '📦 Archiving JMeter results and publishing performance report...'
                archiveArtifacts artifacts: 'jmeter-reports/results.jtl', allowEmptyArchive: true
                archiveArtifacts artifacts: 'jmeter-reports/html/**', allowEmptyArchive: true
                perfReport sourceDataFiles: 'jmeter-reports/results.jtl'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    echo "🐳 Building Docker image: ${DOCKER_FULL_IMAGE}..."
                    sh '''
                        docker build -t ${DOCKER_FULL_IMAGE} .
                        docker tag ${DOCKER_FULL_IMAGE} ${DOCKER_IMAGE}:latest
                    '''
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    echo "📤 Pushing Docker image to Docker Hub..."
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh '''
                            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                            docker push ${DOCKER_FULL_IMAGE}
                            docker push ${DOCKER_IMAGE}:latest
                            docker logout
                        '''
                    }
                }
            }
        }
        stage('Summary') {
            steps {
                script {
                    echo """
                    🎉 CI/CD Pipeline Summary:\n========================\n📦 Docker Image: ${DOCKER_FULL_IMAGE}\n🔖 Build Number: ${BUILD_NUMBER}\n📋 Jira Issue: ${env.JIRA_ISSUE}\n📊 JMeter Results: Available in artifacts\n🐳 Docker Hub: https://hub.docker.com/repository/docker/mohammedsalghi24/sc-grpup-2-devops-project-1\n========================
                    """
                }
            }
        }
    }
    post {
        always {
            echo '🧹 Cleaning up workspace...'
            cleanWs()
        }
        success {
            echo '✅ Pipeline completed successfully!'
        }
        failure {
            echo '❌ Pipeline failed. Check logs for details.'
        }
    }
}
