alias python="python3"
alias pip="pip3"

alias em="emacs -nw -q --load ~/.emacs.d/console-emacs.el"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/harrisontaylor/.conda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
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

export PATH="$HOME/.poetry/bin:$PATH"

export PATH="$HOME/.cargo/bin:$PATH"


function ls-home() {
        excludeDirectories=(
        "Music"
        "Movies"
        "Pictures"
        "Public"
        "Documents"
        "Desktop"
        "Downloads"
        "VirtualBox VMs"
        )

        files=$(comm -23 <( /bin/ls -1) <(printf '%s\n' "${excludeDirectories[@]}" | sort))

        temporary_dir=$(mktemp -d)

        for file in $files; do
                if [ -h $file ]; then
                        ln -s $file $temporary_dir/$file
                elif [ -f $file ]; then
                        touch $temporary_dir/$file
                        if [ -x $file ]; then
                                chmod +x $temporary_dir/$file
                        fi
                else
                        mkdir $temporary_dir/$file
                fi
        done

        /bin/ls $temporary_dir
        rm -rf $temporary_dir
}

function ls-shim() {
        if [ "$(pwd)" = "$HOME" ]; then
                lastArgument="${@:-1}"
                if [ "${lastArgument:0}" = 1 ];  then
                        ls-home
                else
                        /bin/ls "$@"
                fi
        else
                /bin/ls "$@"
        fi
}

alias ls="ls-shim"
