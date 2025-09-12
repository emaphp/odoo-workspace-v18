# The Python version to use
PYTHON_VERSION := 3.10.18

# The name of the folder containing the virtual environment
ODOO_VENV := .venv

# The Docker volume storing the Odoo database
PG_VOLUME := odoo-workspace-v18_pg_odoo

# The Docker network to use
DOCKER_NETWORK := odoo_workspace

# Used to symlink to the modules folder
PARENT_DIR := $(shell cd .. && pwd)
ADDONS_DIR := odoo-modules-v18

setup:
	pyenv install $(PYTHON_VERSION)
	pyenv local $(PYTHON_VERSION)
	pyenv virtualenv $(PYTHON_VERSION) $(ODOO_VENV)

activate:
	pyenv activate $(ODOO_VENV)

install: activate
	pip install -r requirements.txt

symlink:
	ln -s $(PARENT_DIR)/$(ADDONS_DIR) extra-addons

network:
	docker network create $(DOCKER_NETWORK)

up:
	docker compose up -d

down:
	docker compose down

purge:
	@docker compose down
	docker volume rm $(PG_VOLUME)

update:
	git submodule update --remote

.PHONY: setup activate install symlink network up down purge update
