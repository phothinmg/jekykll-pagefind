SHELL := bash

.PHONY: build build-all publish smoke-test

build:
	bash bin/build-platform-gems current

build-all:
	bash bin/build-platform-gems all

smoke-test:
	bash bin/smoke-test

publish:
	bash bin/publish
