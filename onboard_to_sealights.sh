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
#  ./sealights/slcli - CLI tool
#  ./sealights/slgoagent - the agent

rm slgoagent-${OS_ARCH}.tar.gz
rm slcli-${OS_ARCH}.tar.gz

# Add an agent token
cp $AGENT_TOKEN_FILE sealights/

# [Optional] Set debug level (debug | info | error)
#
# If SEALIGHTS_LOG_LEVEL=debug, this file will be created
# ./.sealights-debug-log.json
#
export SEALIGHTS_LOG_LEVEL=info

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

# Scan and instrument the service 
./sealights/slcli scan  \
    --bsid sealights/buildSessionId.txt  \
    --path-to-scanner ./sealights/slgoagent \
    --workspacepath "." \
    --fail-build \
    --scm git
#    --scmBaseUrl <base-url> \
#    --scmProvider github

# Run unit tests
go test -v

# [Optional] Run manual tests
# 1. Build the service (go build)
# 2. Start the service (./go-calc-demo)
# 3. Report the test start (via SL UI)
# 4. Hit the service endpoint(s) (per test script)
# 5. Report the test end (via SL UI)

# Restore files
./sealights/slgoagent clean ./build.json
