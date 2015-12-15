SHELL=/bin/sh

ifndef SKETCH_DIRECTORY
SKETCH_DIRECTORY = ${CURDIR}
endif

ifndef OUTPUT_FOLDERNAME
OUTPUT_FOLDERNAME = output
endif

ifndef OUTPUT_DIRECTORY
OUTPUT_DIRECTORY = $(SKETCH_DIRECTORY)/$(OUTPUT_FOLDERNAME)
endif

define CLEAN_RULE
	@echo "rm -rf '${1}'"
	$(shell rm -rf ${1})
endef

define BUILD_RULE
	processing-java --sketch=$(SKETCH_DIRECTORY) --output=$(OUTPUT_DIRECTORY) --${1} --force
endef

.PHONY: run
run:
	$(call BUILD_RULE,run)

.PHONY: clean
clean:
	$(call CLEAN_RULE, $(OUTPUT_DIRECTORY))