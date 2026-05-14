SHELL := bash

.PHONY: build publish

build:
	gem build jekyll-pagefind.gemspec

publish:
	bash bin/publish
