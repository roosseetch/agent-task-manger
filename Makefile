.PHONY: requirements clean format test install run

# Container settings
PYTHON_VERSION := 3.12
USER_ID := $(shell id -u)
USER_GRP := $(shell id -g)

# Default target
all: requirements install

# Generate requirements.txt from pyproject.toml
requirements:
	@echo "Generating requirements.txt from pyproject.toml..."
	podman run --rm \
	-v $(PWD)/src:/app/src:Z \
	-w /app \
	python:$(PYTHON_VERSION) \
	/bin/bash -c "\
		python -m venv venv && \
		. venv/bin/activate && \
		pip install -U pip-tools && \
		pip-compile --generate-hashes \
		--allow-unsafe \
		--output-file src/requirements.txt \
		--extra dev --resolver=backtracking \
		src/pyproject.toml\
	"
	rm -rf src/*.egg-info

audit:
	@echo "Running safety audit..."
	podman run --rm \
	-v $(PWD)/src:/app/src:Z \
	-w /app \
	python:$(PYTHON_VERSION) \
	/bin/bash -c "\
		python -m venv venv && \
		. venv/bin/activate && \
		pip install safety && \
		safety check --full-report --file src/requirements.txt\
	"

# Install project dependencies
install:
	pip install -r requirements.txt

# Run code formatters
format:
	black src/
	isort src/

# Run tests
test:
	pytest src/tests/

# Clean up generated files
clean:
	rm -rf __pycache__ .pytest_cache
	rm -rf src/__pycache__
	rm -f requirements.txt

# Run the application (placeholder - adjust according to your entry point)
run:
	python -m src.main
