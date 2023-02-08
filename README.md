# go-calc-demo

## Installation

1. Install Go SDK
2. Clone Repository
3. Run `go build`


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

### `master`
Code for the demo

    git clone https://github.com/liornabat-sealights/go-calc-demo.git ./repo/go-calc-demo
 

### `change`
Demo with "pre made" code changes (to show Modified Coverage and Quality Risks)

    git clone -b change  https://github.com/liornabat-sealights/go-calc-demo.git ./repo/go-calc-demo

 - Adds a new func to the calc file - `Power`
 - Changes the `Add` func


## Instrumentation, scanning and test monitoring
See [onboard_to_sealights.sh](https://github.com/ddreakford/go-calc-demo/blob/main/onboard_to_sealights.sh)


## Unit Tests

    go test -v





