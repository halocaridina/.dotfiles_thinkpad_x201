#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

complete -cf sudo

shopt -s cdspell
shopt -s checkwinsize
shopt -s cmdhist
shopt -s dotglob
shopt -s expand_aliases
shopt -s extglob
shopt -s histappend
shopt -s hostcomplete

export EDITOR=/usr/bin/nano
export GCC_COLORS='error=01;38;5;160:warning=01;38;5;220:note=01;38;5;10:caret=01;38;5;33:locus=01:quote=01'
export GREP_OPTIONS=
export GREP_COLORS='fn=00;38;5;33:mc=00;36:ms=31:mt=01;38;5;200:ln=01;38;5;14'

alias ls='ls --color=auto'
alias ll='ls -alh'
alias l='ls -lh'
alias grep='grep --color=auto'
alias less='less -e -i -M -R -q'

if [ "$TERM" != "dumb" ]; then
        eval "`dircolors -b ~/.config/dircolors/dircolorsrc_srs`"
fi

#####################################################################
## Set SSH to use gpg-agent
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
fi

## Set GPG TTY
export GPG_TTY=$(tty)

## Refresh gpg-agent tty in case user switches into an X session
gpg-connect-agent updatestartuptty /bye >/dev/null
#####################################################################

##################################################
# Fancy PWD display function
##################################################
# The home directory (HOME) is replaced with a ~
# The last pwdmaxlen characters of the PWD are displayed
# Leading partial directory names are striped off
# /home/me/stuff          -> ~/stuff               if USER=me
# /usr/share/big_dir_name -> ../share/big_dir_name if pwdmaxlen=20
##################################################

bash_prompt_command() {
	    # How many characters of the $PWD should be kept
	    local pwdmaxlen=25
	    # Indicate that there has been dir truncation
	    local trunc_symbol=".."
	    local dir=${PWD##*/}
	    pwdmaxlen=$(( ( pwdmaxlen < ${#dir} ) ? ${#dir} : pwdmaxlen ))
	    NEW_PWD=${PWD/$HOME/~}
	    local pwdoffset=$(( ${#NEW_PWD} - pwdmaxlen ))
	    if [ ${pwdoffset} -gt "0" ]
	        then
	        NEW_PWD=${NEW_PWD:$pwdoffset:$pwdmaxlen}
	        NEW_PWD=${trunc_symbol}/${NEW_PWD#*/}
	    fi
}
#
bash_prompt() {
    local NONE='\[\033[0m\]'    # unsets color to term's fg color

        # regular colors
	local K='\[\033[0;30m\]'    # black
	local R='\[\033[0;31m\]'    # red
	local G='\[\033[0;32m\]'    # green
	local Y='\[\033[0;33m\]'    # yellow
	local B='\[\033[0;34m\]'    # blue
	local M='\[\033[0;35m\]'    # magenta
	local C='\[\033[0;36m\]'    # cyan
	local W='\[\033[0;37m\]'    # white

	# empahsized (bolded) colors
	local EMK='\[\033[1;30m\]'
	local EMR='\[\033[1;31m\]'
	local EMG='\[\033[1;32m\]'
	local EMY='\[\033[1;33m\]'
	local EMB='\[\033[1;34m\]'
	local EMM='\[\033[1;35m\]'
	local EMC='\[\033[1;36m\]'
	local EMW='\[\033[1;37m\]'

	# background colors
	local BGK='\[\033[40m\]'
	local BGR='\[\033[41m\]'
	local BGG='\[\033[42m\]'
	local BGY='\[\033[43m\]'
	local BGB='\[\033[44m\]'
	local BGM='\[\033[45m\]'
	local BGC='\[\033[46m\]'
	local BGW='\[\033[47m\]'

	local UC=$C                 # user's color
        [ $UID -eq "0" ] && UC=$R   # root's color

	PS1="${W}[\t${W}] ${Y}[${R}\u${R}@${R}\h ${EMB}\${NEW_PWD}${Y}]${W}\\$ ${NONE}"
}
#
PROMPT_COMMAND=bash_prompt_command
bash_prompt
unset bash_prompt

