#!/bin/sh

cd $PROJECT_ROOT_DIR
rm -rf sealights && mkdir sealights

# Download the SeaLights Golang agent files
export OS_ARCH=darwin-arm64
wget -nv https://agents.sealights.co/slgoagent/latest/slgoagent-${OS_ARCH}.tar.gz && \
    tar --cd sealights -xf slgoagent-${OS_ARCH}.tar.gz
wget -nv https://agents.sealights.co/slcli/latest/slcli-${OS_ARCH}.tar.gz && \
    tar --cd sealights -xf slcli-${OS_ARCH}.tar.gz

# Two executables are included with agent:
# - slcli - CLI tool
# - slgoagent - the agent

rm slgoagent-${OS_ARCH}.tar.gz
rm slcli-${OS_ARCH}.tar.gz

# Add an agent token
cp $AGENT_TOKEN_FILE sealights/

# Initialize the SeaLights CLI
./sealights/slcli config init \
  --lang go 
  --token ./sealights/${AGENT_TOKEN_FILE}

# Create a Build Session
export BUILD_TIME=`date +"%y%m%d_%H%M"`
./sealights/slcli config create-bsid \
  --app "go-calc-demo-DD" \
  --branch "main" \
  --build "1.${BUILD_TIME}"
mv buildSessionId.txt sealights

# Scan and instrument the application 
./sealights/slcli scan  \
    --bsid sealights/buildSessionId.txt  \
    --path-to-scanner ./sealights/slgoagent \
    --workspacepath "." \
    --scm git
#    --scmBaseUrl <base-url> \
#    --scmProvider github

# Run tests
go test
