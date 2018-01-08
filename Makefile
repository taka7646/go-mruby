MRUBY_COMMIT ?= 1.2.0

all: libmruby.a libmruby.a.darwin libmruby.a.linux libmruby.a.win64 test

clean:
	rm -rf vendor
	rm -f libmruby.a

gofmt:
	@echo "Checking code with gofmt.."
	gofmt -s *.go >/dev/null

lint:
	sh golint.sh

libmruby.a: vendor/mruby
	cd vendor/mruby && ${MAKE}
	cp vendor/mruby/build/host/lib/libmruby.a .

libmruby.a.darwin: vendor/mruby
	cd vendor/mruby && rake MRUBY_CROSS_OS=darwin MRUBY_CONFIG=../../mruby_build_config.rb
	cp vendor/mruby/build/darwin/lib/libmruby.a ./libmruby.a.darwin

libmruby.a.linux: vendor/mruby
	cd vendor/mruby && rake MRUBY_CROSS_OS=linux MRUBY_CONFIG=../../mruby_build_config.rb
	cp vendor/mruby/build/linux/lib/libmruby.a ./libmruby.a.linux

libmruby.a.win64: vendor/mruby
	cd vendor/mruby && rake MRUBY_CROSS_OS=win64 MRUBY_CONFIG=../../mruby_build_config.rb
	cp vendor/mruby/build/win64/lib/libmruby.a ./libmruby.a.win64

vendor/mruby:
	mkdir -p vendor
	git clone https://github.com/mruby/mruby.git vendor/mruby
	cd vendor/mruby && git reset --hard && git clean -fdx
	cd vendor/mruby && git checkout ${MRUBY_COMMIT}

test: gofmt lint
	go test -v

.PHONY: all clean libmruby.a test lint
