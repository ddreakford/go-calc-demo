# go-calc-demo

## Installation

1. Install Go SDK
2. Clone Repository
3. Run `go build -o go-calc-demo.exe`


## Api Endpoints

### /add
GET http://localhost:8093/add?a=1&b=2
Content-Type: application/json

### /sub
GET http://localhost:8093/sub?a=1&b=2
Content-Type: application/json


### /mul
GET http://localhost:8093/mul?a=1&b=2
Content-Type: application/json

### /div
GET http://localhost:8093/div?a=1&b=2
Content-Type: application/json


## Branches

### master
 contains the code for the demo
 

### change
 contains the code for the demo with the changes:
 - add a new func to the calc file - Power
 - change to the Add func 


## Instrumentation and scanning

Two .exe files are included in the repo:
 - sl.exe - this is the agent
 - slcli.exe - this is the cli tool

Steps to run the instrumentation and scanning the master / change:
1. git clone https://github.com/liornabat-sealights/go-calc-demo.git ./repo/go-calc-demo
  or git clone -b change  https://github.com/liornabat-sealights/go-calc-demo.git ./repo/go-calc-demo
2. ./slcli config init --lang go --token ./token.txt
3. ./slcli config create-bsid --app go-calc-demo --branch master --build <<build number
4. ./slcli.exe scan  --bsid buildSessionId.txt --path-to-scanner ./sl.exe --workspacepath ./repo/go-calc-demo --scm git --scmBaseUrl aaa --scmVersion "0" --scmProvider github

## Unit Tests
Run:
1. go test -v ./...





