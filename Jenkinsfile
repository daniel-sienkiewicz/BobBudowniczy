pipeline {
    agent { label 'openCV' }

    stages {
       stage('Prepare') {
            steps {
                echo 'Preparing..'

                // Clone OpenCV repo
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

                // First solution to just run bash script
                sh '${WORKSPACE}/BobBudowniczy/scripts/build_opencv.sh'

                // This is second solution to use cmake Jenkins plugin and groovy code to get nproc
                //script {
                //    def nproc = sh(script: 'nproc', returnStdout: true).trim()
                //    cmakeBuild generator: 'Unix Makefiles', buildDir: 'build', sourceDir: 'opencv', cleanBuild: true, installation: 'InSearchPath', steps: [[withCmake: true, args: "-j ${nproc}"]]
                //}
            }
        }

        stage('Test') {
            environment {
                TEST_BINARY = './build/bin/opencv_test_flann'
            }
            steps {
                echo 'Testing..'
                sh "mkdir -p ./test_results"
                sh "export GTEST_OUTPUT=xml && ${TEST_BINARY} --gtest_output=xml:./test_results/test_results.xml"
            }
        }
    }

    post {
        always {
            // Publish unit tests results
            xunit (
                thresholds: [ skipped(failureThreshold: '0'), failed(failureThreshold: '0') ],
                tools: [ GoogleTest(pattern: 'test_results/*.xml') ]
            )

            // Publish artifacts
            archiveArtifacts artifacts: 'build/bin/**', onlyIfSuccessful: true
            cleanWs()
        }
    }
}
