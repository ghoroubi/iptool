all: docs binaries

docs: README.md

clean:
	rm -f build_date.txt docs.go README.md iptool

binaries: build_date.txt

iptool: iptool.go
	go get ./...
	go build

build_date.txt: iptool
	go get github.com/mitchellh/gox
	gox -parallel=10
	date > build_date.txt

README.md: docs.go
	> README.md
	echo '# iptool'           >> README.md
	godoc . | sed 's|^|    |' >> README.md

docs.go: iptool
	> docs.go
	echo '/*'                         >> docs.go
	./iptool --help | sed 's|^|    |' >> docs.go
	echo ' */'                        >> docs.go
	echo 'package main'               >> docs.go

.PHONY: all docs clean binaries
