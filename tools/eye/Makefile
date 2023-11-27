SHELL := /usr/bin/env bash
.SHELLFLAGS := -O extglob -c
EYE_HOST := https://github.com/eyereasoner/eye/archive/refs/tags
EYE_VERSION := 8.7.2

.PHONY: all clean

all: eye

clean:
	rm -rf !(Makefile)

eye:
	curl -L $(EYE_HOST)/v$(EYE_VERSION).tar.gz \
	| tar zxvf - --strip-components 1
	./install.sh --prefix=$(CURDIR)
