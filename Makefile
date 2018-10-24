install:
	@printf "\e[0;32m*********\n* > cat Makefilr *\n*********\e[0m\n"

install-my:
	ln -sf ${PWD}/utils.sh /usr/local/bin/my
	@printf ${OK_MSG}

install-zsh:
	brew install z zsh zsh-completions
	sh -c "$$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
	
	rm -rf $${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions
	git clone https://github.com/zsh-users/zsh-completions $${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions
	
	rm -rf $${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
	git clone https://github.com/zsh-users/zsh-autosuggestions $${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
	
	rm -rf $${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	@printf ${OK_MSG}

setup-zsh:
	if [[ ! -f ~/.zshrc.default ]]; then \
		cp -H ~/.zshrc ~/.zshrc.default && rm ~/.zshrc ;\
	fi;
	
	ln -sf ${PWD}/ashatrov.zsh-theme $${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
	ln -sf ${PWD}/.zshrc ~/.zshrc
	@printf ${OK_MSG}

install-ansible:
	sudo easy_install pip
	pip install --upgrade setuptools --user python
	sudo pip install ansible
	@printf ${OK_MSG}

install-vim:
	brew install vim --with-override-system-vim
	@printf ${OK_MSG}

setup-vim:
	mkdir -p ~/.vim/autoload ~/.vim/bundle
	curl -LSso ~/.vim/autoload/pathogen.vim https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim
	
	rm -rf ~/.vim/bundle/nerdtree/ && git clone https://github.com/scrooloose/nerdtree.git ~/.vim/bundle/nerdtree/
	rm -rf ~/.vim/bundle/editorconfig-vim/ && git clone https://github.com/editorconfig/editorconfig-vim.git ~/.vim/bundle/editorconfig-vim/
	rm -rf ~/.vim/bundle/vim-yaml/ && git clone https://github.com/avakhov/vim-yaml ~/.vim/bundle/vim-yaml
	
	if [[ ! -f ~/.vimrc.default ]]; then \
		cp -H ~/.vimrc ~/.vimrc.default && rm ~/.vimrc ;\
	fi;
	
	ln -sf ${PWD}/.vimrc ~/.vimrc
	@printf ${OK_MSG}

osx-settings:
	./.osxdefaults
	@printf ${OK_MSG}
	@echo " - Change OSX settings\n\n"

OK_MSG="\e[0;32m******\n* OK *\n******\e[0m\n"
WARNING_MSG="\e[0;33m***********\n* WARNING *\n***********\e[0m\n"
