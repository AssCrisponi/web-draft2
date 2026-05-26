APPNAME=$(shell grep -m 1 name environment.yml|cut -f2 -d':'|tr -d ' ')
TARGETS=build clean create-env serve
ENV_NAME=${APPNAME}
CONDA_ACTIVATE=source $$(conda info --base)/etc/profile.d/conda.sh ; conda activate ; conda activate

.PHONY: ${TARGETS}

all:
	@echo "Try one of: ${TARGETS}"

build: clean
	mkdocs build

clean:
	find . -name '*.pyc' -delete
	find . -type d -name '__pycache__' -exec rm -rf {} +
	rm -rf dist build site

# Target to create the conda environment if it doesn't exist
create-env:
	@if conda env list | grep "^${ENV_NAME} " >/dev/null 2>&1; then \
 		echo "Environment ${ENV_NAME} already exists."; \
 	else \
 		conda env create --file environment.yml; \
 	fi

serve: clean
	mkdocs serve
