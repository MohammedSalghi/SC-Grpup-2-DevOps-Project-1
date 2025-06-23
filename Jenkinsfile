pipeline {
    agent any

    environment {
        JIRA_SITE = 'MyJira' // Must match the Jira config name in Jenkins
        JIRA_ISSUE = ''      // Will be set dynamically
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
                echo "📝 Posting comment to Jira issue: ${env.JIRA_ISSUE}"
                jiraComment(
                    site: "${env.JIRA_SITE}",
                    issueKey: "${env.JIRA_ISSUE}",
                    body: "✅ Jenkins build completed successfully for ${env.JIRA_ISSUE}. JMeter test results were published."
                )
            }
        }
    }
}
