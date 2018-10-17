.PHONY: setup
setup: setup-coredns setup-forwardif

.PHONY: setup-coredns
setup-coredns:
	@mkdir -p ${GOPATH}/src/github.com/coredns
	@git clone https://github.com/b4fun/coredns.git \
		--branch feat/forward-property \
		${GOPATH}/src/github.com/coredns/coredns

.PHONY: setup-forwardif
setup-forwardif:
	@mkdir -p ${GOPATH}/src/github.com/b4fun
	@git clone --depth=1 https://github.com/b4fun/forwardif.git ${GOPATH}/src/github.com/b4fun/forwardif
	@go get -u github.com/b4fun/adblockdomain

.PHONY: build
build: build-binary build-docker

.PHONY: build-binary
build-binary:
	@sed -i -e \
	    's/forward:forward/forwardif:github.com\/b4fun\/forwardif\/plugin\nforward:forward/g' \
	    ${GOPATH}/src/github.com/coredns/coredns/plugin.cfg
	@sed -i -e \
	    's/DOCKER:=//g' \
	    ${GOPATH}/src/github.com/coredns/coredns/Makefile.release
	@sed -i -e \
	    's/LINUX_ARCH:=amd64 arm arm64 ppc64le s390x/LINUX_ARCH:=amd64 arm64/g' \
	    ${GOPATH}/src/github.com/coredns/coredns/Makefile.release
	@cd ${GOPATH}/src/github.com/coredns/coredns && make core/dnsserver/zdirectives.go
	@cd ${GOPATH}/src/github.com/coredns/coredns && make -f Makefile.release build

.PHONY: build-docker
build-docker:
	@cd ${GOPATH}/src/github.com/coredns/coredns && make -f Makefile.release docker-build

.PHONY: push-docker
push-docker:
	@echo $(DOCKER_PASSWORD) | docker login -u $(DOCKER_LOGIN) --password-stdin
	docker push b4fun/coredns:coredns-amd64
	docker push b4fun/coredns:coredns-arm64
