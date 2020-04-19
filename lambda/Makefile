PWD := ${CURDIR}

clean:
	@rm -rf "$(PWD)"/main
	@rm -rf "$(PWD)"/deployment.zip

build:
	echo "Building binary..."
	GOOS=linux GOARCH=amd64 go build -o main lambda.go

package:
	echo "Create deployment package"
	zip deployment.zip main