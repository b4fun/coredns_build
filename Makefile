.PHONY: setup
setup: setup-coredns setup-forwardif

.PHONY: setup-coredns
setup-coredns:
	@mkdir -p ${GOPATH}/src/github.com/coredns
	@git clone --depth=1 https://github.com/b4fun/coredns.git ${GOPATH}/src/github.com/coredns/coredns
	@git checkout feat/forward-property

.PHONY: setup-forwardif
setup-forwardif:
	@mkdir -p ${GOPATH}/src/github.com/b4fun
	@git clone --depth=1 https://github.com/b4fun/forwardif.git ${GOPATH}/src/github.com/b4fun/forwardif
