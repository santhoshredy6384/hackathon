pipeline {
    agent any

    tools {
        // Configure these tools in Jenkins -> Manage Jenkins -> Global Tool Configuration
        // Name them "Maven 3" and "NodeJS" (or adjust names below to match your config)
        maven 'Maven 3'
        nodejs 'NodeJS'
    }

    stages {
        stage('Checkout') {
            steps {
                // Get code from the SCM (Git)
                checkout scm
            }
        }

        stage('Backend Build') {
            steps {
                dir('Backend') {
                    // Compile and package the Java application
                    // Use 'bat' for Windows agents, 'sh' for Linux agents
                    bat 'mvn clean package -DskipTests'
                }
            }
        }

        stage('Backend Test') {
            steps {
                dir('Backend') {
                    // Run unit tests
                    bat 'mvn test'
                }
            }
            post {
                always {
                    dir('Backend') {
                        junit 'target/surefire-reports/*.xml'
                    }
                }
            }
        }

        stage('Frontend Install') {
            steps {
                dir('Frontend') {
                    // Install Node.js dependencies
                    bat 'npm install'
                }
            }
        }

        stage('Frontend Build') {
            steps {
                dir('Frontend') {
                    // Build the React application
                    bat 'npm run build'
                }
            }
        }
    }
}
