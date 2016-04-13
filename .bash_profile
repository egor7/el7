# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs
PLAN9=/home/vs/plan9port
export PLAN9

PATH=$PATH:$HOME/.local/bin:$HOME/bin:$PLAN9/bin
export PATH
