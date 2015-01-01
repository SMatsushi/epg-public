# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/bin

export PATH

#export PATH="/Applications/microchip/xc8/v1.12/bin":$PATH
#export PATH="/Applications/microchip/xc16/v1.11/bin":$PATH
#export PATH="/Applications/microchip/xc32/v1.20/bin":$PATH

# [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
