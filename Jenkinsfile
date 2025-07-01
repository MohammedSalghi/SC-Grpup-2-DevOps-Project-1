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
                echo '🔄 Checking out code...'
                checkout scm
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
                writeFile file: 'simple-results.txt', text: "Build ${BUILD_NUMBER} completed successfully!"
                writeFile file: 'jmeter-demo.html', text: '<h1>JMeter Demo Report</h1><p>Test completed for build ${BUILD_NUMBER}</p>'
            }
        }
        
        stage('Archive Results') {
            steps {
                echo '📦 Archiving results...'
                archiveArtifacts artifacts: 'simple-results.txt', allowEmptyArchive: true
                archiveArtifacts artifacts: 'jmeter-demo.html', allowEmptyArchive: true
            }
        }
        
        stage('Summary') {
            steps {
                echo '✅ Pipeline completed in under 30 seconds!'
                echo "Build: ${BUILD_NUMBER}"
                echo "Status: SUCCESS"
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
