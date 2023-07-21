.DEFAULT_GOAL := all

.PHONY: help
help: ## Display help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# all: pkg zsh exa git bat tmux fzf ohmyzsh nvim miniconda
all: pkg zsh nvim

.PHONY: pkg-install
pkg-install: ## Install Ubuntu packages
	@./scripts/pkg.sh install

.PHONY: pkg
pkg: pkg-install ## pkg-install

.PHONY: zsh-install
zsh-install: ## Install zsh
	@./scripts/zsh.sh install

.PHONY: zsh-configure
zsh-configure: ## Configure zsh
	@./scripts/zsh.sh configure

.PHONY: zsh
zsh: zsh-install zsh-configure ## zsh-install zsh-configure

.PHONY: nvim-install
nvim-install: ## Install vim
	@./scripts/nvim.sh install

.PHONY: nvim-configure
nvim-configure: ## Configure vim
	@./scripts/nvim.sh configure

.PHONY: nvim
nvim: nvim-install nvim-configure ## vim-install vim-configure
