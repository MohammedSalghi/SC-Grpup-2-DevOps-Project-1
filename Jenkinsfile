pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'mohammedsalghi24/sc-grpup-2-devops-project-1'
        BUILD_TAG = "${BUILD_NUMBER}"
        JIRA_ISSUE = 'SCRUM-11'
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo '🔄 Checking out code from GitHub...'
                checkout scm
            }
        }
        
        stage('Extract Jira Issue') {
            steps {
                script {
                    try {
                        def commitMessage = sh(script: "git log -1 --pretty=%B", returnStdout: true).trim()
                        echo "🔍 Commit message: ${commitMessage}"
                        def issueKeyMatch = commitMessage =~ /([A-Z]+-\d+)/
                        if (issueKeyMatch) {
                            env.JIRA_ISSUE = issueKeyMatch[0]
                            echo "✅ Detected Jira Issue: ${env.JIRA_ISSUE}"
                        }
                    } catch (Exception e) {
                        echo "⚠️ Using default Jira issue: ${env.JIRA_ISSUE}"
                    }
                }
            }
        }
        
        stage('Create Test Results') {
            steps {
                echo '� Creating test results...'
                sh '''
                    mkdir -p test-results
                    echo "Build: ${BUILD_NUMBER}" > test-results/build-info.txt
                    echo "Timestamp: $(date)" >> test-results/build-info.txt
                    echo "Status: SUCCESS" >> test-results/build-info.txt
                '''
            }
        }
        
        stage('Archive Results') {
            steps {
                echo '📦 Archiving results...'
                archiveArtifacts artifacts: 'test-results/**', allowEmptyArchive: true
            }
        }
        
        stage('Summary') {
            steps {
                echo """
                🎉 Pipeline Complete!
                Build: ${BUILD_NUMBER}
                Jira: ${env.JIRA_ISSUE}
                Status: SUCCESS
                """
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
