
all: install_python update

install_python:
	pyenv install $$(cat .python-version) -s

update:
	poetry update

code:
	poetry run code

delete:
	poetry env

# Libraries utilities ----------------------------------------

show:
	poetry show

info:
	poetry run poetry env info -p

delete:
	poetry env remove python

size:
	@echo "Size of libraries"
	@du -sh $$(poetry run poetry env info --path 2>/dev/null)

# Test -------------------------------------------------------------------------------

.PHONY: test
test:
	poetry run mamba -f documentation

.PHONY: .coverage
.coverage:
	poetry run coverage run $(shell poetry run which mamba) -f documentation || true

.PHONY: cover
cover: .coverage
	poetry run coverage report --include 'sdcclient/*'

.PHONY: cover-html
cover-html: .coverage
	poetry run coverage html -d coverage --include 'sdcclient/*'
