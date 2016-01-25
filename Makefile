install:
	@printf "\e[0;32m*********\n* > cat Makefilr *\n*********\e[0m\n"

install-zsh:
	sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

setup-zsh:
	if [[ ! -f ~/.zshrc.default ]]; then \
		cp -H ~/.zshrc ~/.zshrc.default && rm ~/.zshrc ;\
	fi;

	ln -sf ${PWD}/ashatrov.zsh-theme ~/.oh-my-zsh/custom/
	ln -sf ${PWD}/.zshrc ~/.zshrc

setup-vim:
	mkdir -p ~/.vim/autoload ~/.vim/bundle
	curl -LSso ~/.vim/autoload/pathogen.vim https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim

	if [[ ! -f ~/.vimrc.default ]]; then \
		cp -H ~/.vimrc ~/.vimrc.default && rm ~/.vimrc ;\
	fi;

	ln -sf ${PWD}/.vimrc ~/.vimrc

osx-settings:
	./.osxdefaults
	@printf ${OK_MSG}
	@echo " - Change OSX settings\n\n"

OK_MSG="\e[0;32m******\n* OK *\n******\e[0m\n"
WARNING_MSG="\e[0;33m***********\n* WARNING *\n***********\e[0m\n"
