if [ "$PS1" ]; then
	shopt -s checkwinsize cdspell extglob histappend
	alias ll='ls -lF'
	alias ls='ls --color=auto'
	HISTCONTROL=ignoreboth
	HISTIGNORE="[bf]g:exit:quit"
	PS1="[\u@\h \w]\\$ "
	if [ -n "$SSH_CLIENT" ]; then
		PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME%%\.*} \007" && history -a'
	fi
fi
