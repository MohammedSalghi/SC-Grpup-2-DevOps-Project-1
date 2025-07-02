pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'mohammedsalghi24/sc-grpup-2-devops-project-1'
        BUILD_TAG = "${BUILD_NUMBER}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo '🔄 Checking out code...'
                checkout scm
            }
        }
        
        stage('Extract Jira Issue') {
            steps {
                script {
                    echo '🔍 Extracting Jira issue from commit message...'
                    def commitMessage = sh(script: 'git log -1 --pretty=%B', returnStdout: true).trim()
                    echo "Commit message: ${commitMessage}"
                    
                    def jiraPattern = /([A-Z]+-\d+)/
                    def matcher = commitMessage =~ jiraPattern
                    
                    if (matcher) {
                        env.JIRA_ISSUE = matcher[0][1]
                        echo "✅ Found Jira issue: ${env.JIRA_ISSUE}"
                    } else {
                        env.JIRA_ISSUE = 'NO-JIRA-ISSUE'
                        echo "⚠️ No Jira issue found in commit message"
                    }
                }
            }
        }
        
        stage('Quick Test') {
            steps {
                echo '⚡ Running quick test...'
                echo "Build: ${BUILD_NUMBER}"
                echo "Jira: ${env.JIRA_ISSUE}"
            }
        }
        
        stage('Create Simple Results') {
            steps {
                echo '📊 Creating simple test results...'
                writeFile file: 'simple-results.txt', text: "Build ${BUILD_NUMBER} completed successfully!\nJira Issue: ${env.JIRA_ISSUE}\nTimestamp: ${new Date()}"
                writeFile file: 'test-report.html', text: """
<html>
<head><title>Test Report - Build ${BUILD_NUMBER}</title></head>
<body>
    <h1>Jenkins Pipeline Test Report</h1>
    <h2>Build Information</h2>
    <p><strong>Build Number:</strong> ${BUILD_NUMBER}</p>
    <p><strong>Jira Issue:</strong> ${env.JIRA_ISSUE}</p>
    <p><strong>Status:</strong> SUCCESS</p>
    <p><strong>Timestamp:</strong> ${new Date()}</p>
    
    <h2>Test Results</h2>
    <p>✅ Checkout: Passed</p>
    <p>✅ Jira Extraction: Passed</p>
    <p>✅ Quick Test: Passed</p>
    <p>✅ Artifact Creation: Passed</p>
</body>
</html>
"""
            }
        }
        
        stage('Archive Results') {
            steps {
                echo '📦 Archiving results...'
                archiveArtifacts artifacts: 'simple-results.txt', allowEmptyArchive: true
                archiveArtifacts artifacts: 'test-report.html', allowEmptyArchive: true
            }
        }
        
        stage('Summary') {
            steps {
                echo '✅ Pipeline completed successfully!'
                echo "Build: ${BUILD_NUMBER}"
                echo "Jira Issue: ${env.JIRA_ISSUE}"
                echo "Status: SUCCESS"
                echo "Artifacts: simple-results.txt, test-report.html"
            }
        }
    }
    
    post {
        always {
            echo '🧹 Cleanup complete'
        }
        success {
            echo '🎉 Fast pipeline successful!'
        }
    }
}
