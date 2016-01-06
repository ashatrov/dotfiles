install: zsh
	@printf "\e[0;32m*********\n* DONE! *\n*********\e[0m\n"

zsh:
	$(warning ...)
	@if [ -a ~/.zshrc ]; \
	then \
  		cp ashatrov.zsh-theme ~/.oh-my-zsh/custom/ ;\
		sed -i .backup -e 's/^ZSH_THEME=.*/ZSH_THEME="ashatrov"/g' ~/.zshrc ;\
		printf ${OK_MSG} ;\
		echo " - Change ZSH theme to 'ashatrov' inside ~/.zshrc file.\n - New theme is here ~/.oh-my-zsh/custom/ashatrov.zsh-theme.\n - Backup created ~/.zshrc.backup\n\n" ;\
	else \
		printf ${WARNING_MSG} ;\
		echo "ZSH not found\n\n" ;\
	fi;

OK_MSG="\e[0;32m******\n* OK *\n******\e[0m\n"
WARNING_MSG="\e[0;33m***********\n* WARNING *\n***********\e[0m\n"


