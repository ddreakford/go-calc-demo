pipeline {
    agent any

    parameters {
        string(name: 'BRANCH', defaultValue: 'main', description: 'The branch to locally clone, build and onboard to SeaLights')
        string(name: 'DOCKER_REPO', defaultValue: 'dwaynedreakford', description: 'Your Docker repo')
        string(name: 'APP_IMAGE_NAME', defaultValue: 'go_calc_demo', description: 'Name of the image to be deployed')
        string(name: 'OS_ARCH', defaultValue: 'darwin-arm64', description: 'Target architecture for the Go executable')
        string(name: 'SEALIGHTS_LOG_LEVEL', defaultValue: 'info', description: 'SeaLights agent logging (debug|info|error)')
    }
    environment {
        SL_APP_NAME = "go-calc-demo-DD"
        SL_BUILD_NAME = "1.0.${BUILD_NUMBER}"
    }
    tools {
        go '1.20.1'
    }

    stages {
        stage('SCM (Git)') {
            steps {
                cleanWs()
                git branch: params.BRANCH, url: 'https://github.com/ddreakford/go-calc-demo.git'
            }
        }
        stage('Install/Configure SeaLights agent') {
            steps {
                withCredentials([string(credentialsId: 'SL_AGENT_TOKEN', variable: 'SL_TOKEN')]) {
                    // 1. Download the agent
                    // 2. Save the agent token in a file
                    // 3. Intialize the SeaLights CLI
                    sh '''
                        rm -rf sealights && mkdir sealights

                        wget -nv https://agents.sealights.co/slgoagent/latest/slgoagent-${OS_ARCH}.tar.gz && \
                            tar --cd sealights -xf slgoagent-${OS_ARCH}.tar.gz
                        wget -nv https://agents.sealights.co/slcli/latest/slcli-${OS_ARCH}.tar.gz && \
                            tar --cd sealights -xf slcli-${OS_ARCH}.tar.gz

                        rm slgoagent-${OS_ARCH}.tar.gz
                        rm slcli-${OS_ARCH}.tar.gz

                        echo $SL_TOKEN > sealights/sltoken.txt
                        ls -l sealights

                        ./sealights/slcli config init --lang go --token ./sealights/sltoken.txt
                    '''
                }
            }
        }

        stage('Create the SL Build ID') {
            steps {
                // buildSessionId.txt is written by this step
                sh """
                    ./sealights/slcli config create-bsid \
                        --app "${SL_APP_NAME}" \
                        --branch "${BRANCH}" \
                        --build "1.${SL_BUILD_NAME}"
                    mv buildSessionId.txt sealights
                    cat sealights/buildSessionId.txt
                """
            }
        }

        stage('Scan and instrument the service') {
            // This step creates the build map
            // IF NEEDED, also specify:
            //  --scmBaseUrl <base-url>
            //  --scmProvider github
            steps {
                sh """
                    ./sealights/slcli scan  \
                        --bsid sealights/buildSessionId.txt  \
                        --path-to-scanner ./sealights/slgoagent \
                        --workspacepath "." \
                        --scm git
                """
            }
        }

        stage('Unit Tests') {
            steps {
                sh '''
                    go test -v
                '''
            }
        }
        stage('Deploy to QA') {
            steps {
                script {
                    // Create/start a container with SeaLights monitoring
                    String APP_IMAGE_SPEC = "${DOCKER_REPO}/${APP_IMAGE_NAME}:${BUILD_NUMBER}"
                    sh """
                        docker build -f Dockerfile.qa -t ${APP_IMAGE_SPEC} .
                        docker run --name ${APP_IMAGE_NAME} -d -p 8093:8093 ${APP_IMAGE_SPEC}
                    """
                }
            }
        }
    }
}