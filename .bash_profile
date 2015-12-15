alias ll='ls -lahG'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias dockerviz="docker run --rm -v /var/run/docker.sock:/var/run/docker.sock nate/dockviz"
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

#export PS1='\e[32;40m\t local:\e[36;40m\W\e[0m \$ '
export PS1='\t MacBook:\W \$ '

# Add tab completion for many Bash commands
if which brew > /dev/null && [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
	source "$(brew --prefix)/share/bash-completion/bash_completion";
elif [ -f /etc/bash_completion ]; then
	source /etc/bash_completion;
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;


# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

export PATH="/usr/local/sbin:$PATH"
