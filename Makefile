SHELL := /usr/bin/env bash
RULES := $(shell find rules -name '*.n3')

.PHONY: all clean superclean validate

all: submission.zip

clean:
	rm -f report-*.ttl inferred.ttl inferred-without-ontology.ttl all.ttl

superclean: clean
	$(MAKE) -s -C tools/eye clean
	$(MAKE) -s -C tools/jena clean

tools/eye/bin/eye:
	which swipl || \
	(sudo apt update \
	&& sudo apt -y install software-properties-common \
	&& sudo apt-add-repository -y ppa:swi-prolog/stable \
	&& sudo apt update \
	&& sudo apt -y install swi-prolog)
	$(MAKE) -s -C tools/eye

tools/jena/bin/arq \
tools/jena/bin/riot \
tools/jena/bin/shacl:
	which java || \
	(sudo apt update && sudo apt -y install default-jre)
	$(MAKE) -s -C tools/jena

report-invalid.ttl: data-invalid.ttl shapes.ttl | tools/jena/bin/shacl
	./tools/jena/bin/shacl validate --shapes shapes.ttl --data $< > $@

report-valid.ttl: data-valid.ttl shapes.ttl | tools/jena/bin/shacl
	./tools/jena/bin/shacl validate --shapes shapes.ttl --data $< > $@

inferred-without-ontology.ttl: \
$(RULES) data-valid.ttl \
| tools/eye/bin/eye tools/jena/bin/riot
	./tools/eye/bin/eye $^ --pass-only-new \
	| ./tools/jena/bin/riot --syntax=ttl --formatted=ttl - \
	> $@

inferred.ttl: \
$(RULES) data-valid.ttl ontology.ttl \
| tools/eye/bin/eye tools/jena/bin/riot
	./tools/eye/bin/eye $^ --pass-only-new \
	| ./tools/jena/bin/riot --syntax=ttl --formatted=ttl - \
	> $@

all.ttl: data-valid.ttl ontology.ttl inferred.ttl | tools/jena/bin/riot
	./tools/jena/bin/riot --formatted=ttl $^ > $@

check-results: \
report-invalid.ttl report-valid.ttl inferred.ttl inferred-without-ontology.ttl
	@[[ $$(./tools/jena/bin/arq --data report-invalid.ttl --query conforms.rq) == "Ask => No" ]] \
	|| ( printf "\nValidation should have failed, but it did not:\n\n" && cat report-invalid.ttl && exit 1)
	@[[ $$(./tools/jena/bin/arq --data report-valid.ttl --query conforms.rq) == "Ask => Yes" ]] \
	|| ( printf "\nValidation failed, but it should not have:\n\n" && cat report-valid.ttl && exit 1)
	@[[ $$(( $$(./tools/jena/bin/riot --count inferred.ttl 2>&1 | cut -d ' ' -f 5) - \
	        $$(./tools/jena/bin/riot --count inferred-without-ontology.ttl 2>&1 | cut -d ' ' -f 5) )) > 0 ]] \
	|| ( printf "\nNo triples were inferred based on your ontology!\n\n" && exit 1 )

submission.zip: \
all.ttl \
data-invalid.ttl \
data-valid.ttl \
inferred.ttl \
ontology.ttl \
report-invalid.ttl \
report-valid.ttl \
shapes.ttl \
| check-results
	which zip || \
	(sudo apt update && sudo apt -y install zip)
	zip $@ $^
