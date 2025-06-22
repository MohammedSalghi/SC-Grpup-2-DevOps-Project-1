pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code from GitHub...'
                git branch: 'main', url: 'https://github.com/MohammedSalghi/SC-Grpup-2-DevOps-Project-1.git'
            }
        }

        stage('Build') {
            steps {
                echo 'Building the application...'
            }
        }

        stage('Performance Test') {
            steps {
                echo 'Running performance tests...'
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
                echo 'Updating Jira issue...'
                jiraComment body: "✅ Jenkins build for SCRUM-11 completed successfully. Performance test results attached."
            }
        }
    }
}
