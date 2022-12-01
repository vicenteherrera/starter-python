


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
