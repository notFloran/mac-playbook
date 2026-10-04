ANSIBLE_WITH_PASSWORD_COMMAND = ansible-playbook -c local -i inventory --ask-become-pass
ANSIBLE_WITHOUT_PASSWORD_COMMAND = ansible-playbook -c local -i inventory_sudo_password
ANSIBLE_COMMAND := $(if $(shell grep "sudo_password: !vault" config.yml),$(ANSIBLE_WITHOUT_PASSWORD_COMMAND),$(ANSIBLE_WITH_PASSWORD_COMMAND))
CONFIG_EDITOR = $(or $(DEV_CONFIG_EDITOR) , vim)

ANSIBLE_PLAYBOOK_SETUP=$(ANSIBLE_COMMAND) playbooks/setup.yml
tags = all

.DEFAULT_GOAL := help
default: help

.PHONY: help
help:
	@echo "mac-playbook"
	@echo ""
	@echo "New issue : https://github.com/notFloran/mac-playbook/issues/new"
	@echo ""
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: tags
tags: ## List all tags
	@$(ANSIBLE_PLAYBOOK_SETUP) --list-tags

.PHONY: bootstrap
bootstrap: ## Bootstrap the dev environment for the first time
	@scripts/bootstrap.sh "$(ansible_version_spec)"

.PHONY: install-ansible
install-ansible: ## Install ansible, you can install a specific version with: ansible_version_spec=<2.18
	@scripts/install-ansible.sh "$(ansible_version_spec)"

.PHONY: setup
setup: ## Setup the dev environment
	@$(ANSIBLE_PLAYBOOK_SETUP) --tags=$(tags)

.PHONY: upgrade
upgrade: ## Upgrade of the apps and dev environment
	@echo "Upgrade apps"
	@echo ""
	@brew cu -y --cleanup
	@echo ""
	@echo "Upgrade of the dev environment"
	@echo ""
	@$(ANSIBLE_PLAYBOOK_SETUP) --extra-vars='upgrade_all_packages=true' --tags=$(tags)

.PHONY: dotfiles
dotfiles: ## Setup "dotfiles"
	@$(ANSIBLE_PLAYBOOK_SETUP) --tags="dotfiles"

.PHONY: config
config: ## Edit config
	@$(CONFIG_EDITOR) config.yml

.PHONY: update
update: ## Pull the last version of the dev environment
	@git pull origin main
