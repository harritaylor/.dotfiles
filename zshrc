# Fix for tramp https://blog.karssen.org/2016/03/02/fixing-emacs-tramp-mode-when-using-zsh/
[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ ' && return

# Add `~/bin` to `$PATH`
export PATH=$HOME/bin:$PATH
export PATH="/usr/local/sbin:$PATH"
export PATH=$HOME/.emacs.d/bin:$PATH

# Add path to fzf
# export FZF_BASE=/usr/local/bin/fzf

# Path to oh-my-zsh & zsh settings
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="fishy"
DISABLE_UPDATE_PROMPT="true"
ENABLE_CORRECTION="true"
#COMPLETION_WAITING_DOTS="true"
plugins=(git fzf pass)
source $ZSH/oh-my-zsh.sh

# Vi bindings in zsh
bindkey -v
# For NV in vim (might be fixed with plugins)
# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
#for file in ~/.{exports,aliases,functions,extra}; do
for file in .{path,aliases,exports,functions,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
# [ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/harrisontaylor/.conda/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/harrisontaylor/.conda/etc/profile.d/conda.sh" ]; then
        . "/Users/harrisontaylor/.conda/etc/profile.d/conda.sh"
    else
        export PATH="/Users/harrisontaylor/.conda/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# PyEnv
#export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"
#if command -v pyenv 1>/dev/null 2>&1; then
#  eval "$(pyenv init -)"
#fi
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

#alias ssh="~/bin/ssh/colour.sh"
