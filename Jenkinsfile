pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code from GitHub...'
                checkout scm
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
                script {
                    // Run JMeter test
                    sh 'jmeter -n -t performance-test.jmx -l results.jtl'
                }
            }
        }
        
        stage('Publish Results') {
            steps {
                // Publish performance test results
                perfReport sourceDataFiles: 'results.jtl'
            }
        }
    }
}
