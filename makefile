BREW_PACKAGES := cosign tenv terraform-docs tflint checkov trivy pre-commit checkov
INSTALLER_PATH := $(shell { command -v brew || command -v apt || command -v dnf; } 2>/dev/null)
INSTALLER := $(shell { basename $(INSTALLER_PATH); } 2>/dev/null)

.PHONY: install
install: install_$(INSTALLER)

.PHONY: install_brew
install_brew:
	brew tap hashicorp/tap
	brew install $(BREW_PACKAGES)
	tenv terraform install
	tenv terragrunt install

.PHONY: install_
install_:
	@echo "Not yet implemented"

.PHONY: precommit_install
precommit_install:
	pre-commit install

.terraform:
	terraform init --backend=false

.PHONY: test_validation
test_validation:
	terraform validate

.PHONY: test_tflint
test_tflint:
	tflint --init
	tflint

.PHONY: terratest
terratest:
	@echo "Not yet implemented."

.PHONY: security
security: test_checkov test_trivy

.PHONY: test_checkov
test_checkov:
	checkov --directory .

.PHONY: test_trivy
test_trivy:
	trivy config .

.PHONY: terraform_test
terraform_test:
	@echo "Not yet implemented."

.PHONY: chores
chores: documentation format

.PHONY: documentation
documentation:
	terraform-docs -c .terraform-docs.yml .

.PHONY: test_documentation
test_documentation:
	terraform-docs -c .terraform-docs.yml --output-check .

.PHONY: format
format:
	terraform fmt -recursive .

.PHONY: test_format
test_format:
	terraform fmt -check -recursive .
