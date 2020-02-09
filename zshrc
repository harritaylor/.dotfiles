# Add `~/bin` to `$PATH`
export PATH=$HOME/bin:$PATH
export PATH="/usr/local/sbin:$PATH"

# Add path to fzf
export FZF_BASE=/usr/local/bin/fzf

# Path to oh-my-zsh & zsh settings
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="fishy"
DISABLE_UPDATE_PROMPT="true"
ENABLE_CORRECTION="true"
#COMPLETION_WAITING_DOTS="true"
plugins=(git taskwarrior fzf)
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


