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
	@go get -u github.com/b4fun/forwardif/plugin
	@go get -u github.com/b4fun/adblockdomain

.PHONY: build
build:
	@sed -i -e \
	    's/forward:forward/forwardif:github.com\/b4fun\/forwardif\/plugin\nforward:forward/g' \
	    ${GOPATH}/src/github.com/coredns/coredns/plugin.cfg
	@cd ${GOPATH}/src/github.com/coredns/coredns && make
