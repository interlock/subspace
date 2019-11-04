all: subspace-linux-amd64 subspace-linux-arm

BUILD_VERSION?=unknown

subspace-linux-amd64:
	go generate \
	&& go fmt \
	&& go vet --all
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
	go build -v --compiler gc --ldflags "-extldflags -static -s -w -X main.version=${BUILD_VERSION}" -o subspace-linux-amd64

subspace-linux-arm:
	go generate \
	&& go fmt \
	&& go vet --all
	CGO_ENABLED=0 GOOS=linux GOARCH=arm GOARM=5 \
	go build -v --compiler gc --ldflags "-extldflags -static -s -w -X main.version=${BUILD_VERSION}" -o subspace-linux-arm5

subspace-linux-arm-docker: subspace-linux-arm
	docker build -t subspace -f Dockerfile.arm5 .

clean:
	rm -f subspace-linux-amd64 bindata.go
	rm -f subspace-linux-arm5 bindata.go

.PHONY: clean
