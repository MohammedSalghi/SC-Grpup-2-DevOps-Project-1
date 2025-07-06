# Jenkins Pipeline Integration for Jira
# Add this to your Jenkinsfile to automatically update Jira

pipeline {
    agent any
    
    environment {
        JIRA_SITE = 'your-jira-site'
        JIRA_PROJECT = 'YOUR-PROJECT'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
                script {
                    // Extract Jira issue from commit message or branch name
                    env.JIRA_ISSUE = sh(
                        script: "git log -1 --pretty=%B | grep -o '[A-Z]\\+-[0-9]\\+' | head -1",
                        returnStdout: true
                    ).trim()
                }
            }
        }
        
        stage('Build') {
            steps {
                echo 'Building application...'
                // Your build steps here
                
                script {
                    if (env.JIRA_ISSUE) {
                        // Update Jira with build start
                        jiraAddComment(
                            comment: "🔨 Build #${BUILD_NUMBER} started at ${new Date()}",
                            issueKey: env.JIRA_ISSUE
                        )
                    }
                }
            }
        }
        
        stage('Test') {
            steps {
                echo 'Running tests...'
                // Your test steps here
                
                script {
                    if (env.JIRA_ISSUE) {
                        jiraAddComment(
                            comment: "✅ Tests passed for build #${BUILD_NUMBER}",
                            issueKey: env.JIRA_ISSUE
                        )
                    }
                }
            }
        }
        
        stage('Deploy') {
            steps {
                echo 'Deploying application...'
                // Your deployment steps here
                
                script {
                    if (env.JIRA_ISSUE) {
                        jiraAddComment(
                            comment: "🚀 Deployment completed for build #${BUILD_NUMBER}\\nURL: http://localhost:8080",
                            issueKey: env.JIRA_ISSUE
                        )
                        
                        // Transition issue to "In Review" or "Done"
                        jiraTransitionIssue(
                            issueKey: env.JIRA_ISSUE,
                            transitionInput: [
                                transition: [
                                    id: '31' // Adjust this ID based on your Jira workflow
                                ]
                            ]
                        )
                    }
                }
            }
        }
    }
    
    post {
        success {
            script {
                if (env.JIRA_ISSUE) {
                    jiraAddComment(
                        comment: "✅ Pipeline completed successfully for build #${BUILD_NUMBER}",
                        issueKey: env.JIRA_ISSUE
                    )
                }
            }
        }
        
        failure {
            script {
                if (env.JIRA_ISSUE) {
                    jiraAddComment(
                        comment: "❌ Pipeline failed for build #${BUILD_NUMBER}\\nCheck logs: ${BUILD_URL}console",
                        issueKey: env.JIRA_ISSUE
                    )
                }
            }
        }
    }
}
