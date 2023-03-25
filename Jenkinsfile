pipeline {
    agent { label 'openCV' }

    stages {
       stage('Prepare') {
            steps {
                echo 'Preparing..'
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/4.x']],
                    userRemoteConfigs: [[url: 'https://github.com/opencv/opencv']],
                    extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'opencv']]
                ])
            }
        }

        stage('Build') {
            steps {
                echo 'Building..'
                sh '${WORKSPACE}/BobBudowniczy/scripts/build_opencv.sh'
            }
        }

        stage('Test') {
            environment {
                TEST_BINARY = './build/bin/opencv_test_flann'
            }
            steps {
                echo 'Testing..'
                sh "mkdir -p ./test_results && export GTEST_OUTPUT=xml && ${TEST_BINARY} --gtest_output=xml:./test_results/test_results.xml"
            }
        }
    }

    post {
        always {
            xunit (
                thresholds: [ skipped(failureThreshold: '0'), failed(failureThreshold: '0') ],
                tools: [ GoogleTest(pattern: 'test_results/*.xml') ]
            )
            archiveArtifacts artifacts: 'build/bin/**', onlyIfSuccessful: true
            cleanWs()
        }
    }
}
