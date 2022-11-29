SHELL := /usr/bin/env bash
.SHELLFLAGS := -O extglob -c
EYE_HOST := https://github.com/josd/eye/archive/refs/tags
EYE_VERSION := 22.1126.0121

.PHONY: all clean

all: eye

clean:
	rm -rf !(Makefile)

eye:
	curl -L $(EYE_HOST)/v$(EYE_VERSION).tar.gz \
	| tar zxvf - --strip-components 1
	./install.sh --prefix=$(CURDIR)
