pipeline {
    agent any

    environment {
        JIRA_SITE = 'MyJira' // 🔁 Make sure this matches the site name in Jenkins Jira configuration
        JIRA_ISSUE = 'SCRUM-11' // 🔁 Change to the correct issue or make it dynamic if needed
    }

    stages {
        stage('Checkout') {
            steps {
                echo '🔄 Checking out code from GitHub...'
                git branch: 'main', url: 'https://github.com/MohammedSalghi/SC-Grpup-2-DevOps-Project-1.git'
            }
        }

        stage('Build') {
            steps {
                echo '🏗️ Building the application...'
                // You can add actual build steps here
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

        stage('Update Jira Issue') {
            steps {
                echo '📝 Posting comment to Jira issue...'
                jiraComment(
                    site: "${JIRA_SITE}",
                    issueKey: "${JIRA_ISSUE}",
                    body: "✅ Jenkins build completed successfully for ${JIRA_ISSUE}. JMeter test results were published."
                )
            }
        }
    }
}
