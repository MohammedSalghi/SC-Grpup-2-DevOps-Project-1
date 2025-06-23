pipeline {
    agent any

    environment {
        JIRA_SITE = 'MyJira' // 🔁 Must match your Jira site ID in Jenkins global config
        JIRA_ISSUE = ''      // Will be extracted dynamically
        DOCKER_IMAGE = 'mohammedsalghi24/sc-grpup-2-devops-project-1:latest' // 🔁 Your Docker Hub repo
    }

    stages {
        stage('Checkout') {
            steps {
                echo '🔄 Checking out code from GitHub...'
                git branch: 'main', url: 'https://github.com/MohammedSalghi/SC-Grpup-2-DevOps-Project-1.git'
            }
        }

        stage('Extract Jira Issue Key') {
            steps {
                script {
                    def commitMessage = sh(script: "git log -1 --pretty=%B", returnStdout: true).trim()
                    echo "🔍 Commit message: ${commitMessage}"

                    def issueKeyMatch = commitMessage =~ /([A-Z]+-\d+)/
                    if (issueKeyMatch) {
                        env.JIRA_ISSUE = issueKeyMatch[0][1]
                        echo "✅ Detected Jira Issue Key: ${env.JIRA_ISSUE}"
                    } else {
                        error("❌ No Jira issue key found in commit message.")
                    }
                }
            }
        }

        stage('Build') {
            steps {
                echo '🏗️ Building the application...'
                // Optional: build steps (e.g., npm run build)
            }
        }

        stage('Performance Test') {
            steps {
                echo '🚀 Running performance tests with JMeter...'
                sh '''
                docker pull justb4/jmeter

                docker run --rm -v "$PWD":/tests justb4/jmeter \
                  -n -t /tests/jmeter/test-plan.jmx -l /tests/results.jtl

                docker run --rm -v "$PWD":/tests justb4/jmeter \
                  -g /tests/results.jtl -o /tests/html-report
                '''
            }
        }

        stage('Publish Results') {
            steps {
                echo '📊 Publishing JMeter test report...'
                publishHTML([
                    allowMissing: false,
                    alwaysLinkToLastBuild: true,
                    keepAll: true,
                    reportDir: 'html-report',
                    reportFiles: 'index.html',
                    reportName: 'JMeter Report'
                ])
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "🐳 Building Docker image: ${DOCKER_IMAGE}..."
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Push Docker Image') {
            steps {
                echo "📤 Pushing Docker image to Docker Hub..."
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                    echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                    docker push $DOCKER_IMAGE
                    docker logout
                    '''
                }
            }
        }

        stage('Update Jira Issue') {
            steps {
                echo "📝 Posting comment to Jira issue: ${env.JIRA_ISSUE}"
                jiraComment(
                    site: "${env.JIRA_SITE}",
                    issueKey: "${env.JIRA_ISSUE}",
                    body: "✅ Jenkins built and pushed Docker image `${DOCKER_IMAGE}` and ran performance tests for issue ${env.JIRA_ISSUE}."
                )
            }
        }
    }
}
